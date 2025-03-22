//
//  SimulationView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//


import SwiftUI

struct SimulationView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fuzzy Auto Brake Simulation")
                .font(.headline)
            
            ZStack {
                // Road
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        // Road markings
                        HStack(spacing: 20) {
                            ForEach(0..<20) { _ in
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 30, height: 5)
                            }
                        }
                    )
                
                // Car
                CarView(model: model)
                    .position(x: model.carPosition + model.carWidth / 2, y: 50)
                
                // Obstacle
                ObstacleView(model: model)
                    .position(x: model.obstaclePosition + model.obstacleWidth / 2, y: 50)
                
                // Distance indicator
                if !model.isSimulationRunning {
                    DistanceIndicatorView(model: model)
                }
            }
            .frame(height: 100)
            .clipped()
            
            // Simulation controls
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current Speed: \(Int(model.carSpeed)) km/h")
                    Text("Distance to Obstacle: \(String(format: "%.1f", model.distanceToObstacle)) m")
                    Text("Brake Force: \(Int(model.brakeIntensity))%")
                }
                
                Spacer()
                
                VStack {
                    HStack {
                        Button(action: {
                            model.stopSimulation()
                            model.resetSimulation()
                        }) {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            if model.isSimulationRunning {
                                model.stopSimulation()
                            } else {
                                model.startSimulation()
                            }
                        }) {
                            Label(model.isSimulationRunning ? "Stop" : "Start", systemImage: model.isSimulationRunning ? "stop.fill" : "play.fill")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    // Simulation speed slider
                    HStack {
                        Text("Speed: \(String(format: "%.1fx", model.simulationSpeed))")
                            .font(.caption)
                        
                        Slider(value: $model.simulationSpeed, in: 0.1...3.0, step: 0.1)
                            .frame(width: 150)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
}

