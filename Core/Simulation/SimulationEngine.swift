//
//  SimulationEngine.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import Foundation
import SwiftUI
import Combine

class SimulationEngine: ObservableObject {
    // Fuzzy Logic Engine
    @Published var fuzzyEngine = FuzzyLogicEngine()
    
    // Car properties
    @Published var carSpeed: Double = 80.0 // km/h
    @Published var carPosition: CGFloat = 100.0 // pixels
    @Published var carWidth: CGFloat = 60.0
    @Published var carHeight: CGFloat = 40.0
    
    // Obstacle properties
    @Published var obstaclePosition: CGFloat = 700.0 // pixels
    @Published var obstacleWidth: CGFloat = 60.0
    @Published var obstacleHeight: CGFloat = 40.0
    
    // Simulation properties
    @Published var distanceToObstacle: Double = 100.0 // meters
    @Published var brakeIntensity: Double = 0.0 // percentage 0-100
    @Published var activeRules: [FuzzyRule] = []
    @Published var isSimulationRunning: Bool = false
    @Published var simulationSpeed: Double = 1.0 // simulation speed multiplier
    
    // Scale factors for converting between simulation and display
    let pixelsPerMeter: CGFloat = 5.0
    let speedScaleFactor: Double = 0.1 // Scale factor for speed to pixels movement
    
    // Timer for simulation updates
    private var timer: AnyCancellable?
    
    init() {
        updateDistanceToObstacle()
    }
    
    func resetSimulation() {
        carSpeed = 80
        carPosition = 100.0
        updateDistanceToObstacle()
        brakeIntensity = 0.0
        activeRules = []
    }
    
    func startSimulation() {
        // Start the simulation timer
        if timer == nil {
            timer = Timer.publish(every: 0.03, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.updateSimulation()
                }
        }
        isSimulationRunning = true
    }
    
    func stopSimulation() {
        // Stop the simulation timer
        timer?.cancel()
        timer = nil
        isSimulationRunning = false
    }
    
    private func updateSimulation() {
        // Skip update if car has passed obstacle
        guard carPosition + carWidth < obstaclePosition else {
            stopSimulation()
            return
        }
        
        // Apply fuzzy logic to determine brake intensity
        let (brakeValue, rules) = fuzzyEngine.inferBrakeIntensity(speed: carSpeed, distance: distanceToObstacle)
        brakeIntensity = brakeValue
        activeRules = rules
        
        // Calculate new speed based on braking
        // The braking effect is proportional to the current speed and brake intensity
        let brakeDeceleration = (brakeIntensity / 100.0) * (carSpeed / 10.0) * simulationSpeed
        carSpeed = max(0, carSpeed - brakeDeceleration)
        
        // Move car forward based on current speed
        let pixelMovement = carSpeed * speedScaleFactor * simulationSpeed
        carPosition += CGFloat(pixelMovement)
        
        // Update distance to obstacle
        updateDistanceToObstacle()
        
        // Stop simulation if car has stopped
        if carSpeed <= 0.1 {
            carSpeed = 0
            stopSimulation()
        }
    }
    
    private func updateDistanceToObstacle() {
        // Calculate distance in pixels and convert to meters
        let distanceInPixels = obstaclePosition - (carPosition + carWidth)
        distanceToObstacle = Double(max(0, distanceInPixels / pixelsPerMeter))
    }
    
    // Set car position based on distance to obstacle
    func setDistanceToObstacle(_ distance: Double) {
        distanceToObstacle = distance
        let distanceInPixels = CGFloat(distance * Double(pixelsPerMeter))
        carPosition = obstaclePosition - distanceInPixels - carWidth
    }
    
    // Restart car at a specified distance
    func restartCarAt(distance: Double, speed: Double) {
        stopSimulation()
        carSpeed = speed
        setDistanceToObstacle(distance)
        startSimulation()
    }
} 
