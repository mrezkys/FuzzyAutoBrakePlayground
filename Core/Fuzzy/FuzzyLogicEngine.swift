//
//  FuzzyLogicEngine.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import Foundation

// Fuzzy Logic Engine
class FuzzyLogicEngine: ObservableObject {
    @Published var speedFunctions: [SpeedVariable: MembershipFunction] = [:]
    @Published var distanceFunctions: [DistanceVariable: MembershipFunction] = [:]
    @Published var brakeFunctions: [BrakeVariable: MembershipFunction] = [:]
    @Published var rules: [FuzzyRule] = []
    
    @Published var activeRules: [FuzzyRule] = []
    
    init() {
        setupDefaultFunctions()
        setupDefaultRules()
    }
    
    func setupDefaultFunctions() {
        // Default Speed membership functions
        speedFunctions = [
            .slow: MembershipFunction(type: .triangular, name: "Slow", points: [0, 0, 40]),
            .moderate: MembershipFunction(type: .triangular, name: "Moderate", points: [20, 50, 80]),
            .fast: MembershipFunction(type: .triangular, name: "Fast", points: [60, 90, 120]),
            .veryFast: MembershipFunction(type: .trapezoidal, name: "Very Fast", points: [100, 130, 200, 200])
        ]
        
        // Default Distance membership functions
        distanceFunctions = [
            .veryNear: MembershipFunction(type: .triangular, name: "Very Near", points: [0, 0, 10]),
            .near: MembershipFunction(type: .triangular, name: "Near", points: [5, 15, 25]),
            .medium: MembershipFunction(type: .triangular, name: "Medium", points: [20, 40, 60]),
            .far: MembershipFunction(type: .trapezoidal, name: "Far", points: [50, 80, 150, 150])
        ]
        
        // Default Brake membership functions
        brakeFunctions = [
            .noBrake: MembershipFunction(type: .triangular, name: "No Brake", points: [0, 0, 20]),
            .lightBrake: MembershipFunction(type: .triangular, name: "Light Brake", points: [10, 25, 40]),
            .moderateBrake: MembershipFunction(type: .triangular, name: "Moderate Brake", points: [30, 50, 70]),
            .strongBrake: MembershipFunction(type: .triangular, name: "Strong Brake", points: [60, 75, 90]),
            .emergencyBrake: MembershipFunction(type: .triangular, name: "Emergency Brake", points: [80, 100, 100])
        ]
    }
    
    func setupDefaultRules() {
        rules = [
            FuzzyRule(speedCondition: .slow, distanceCondition: .veryNear, brakeConsequence: .moderateBrake),
            FuzzyRule(speedCondition: .slow, distanceCondition: .near, brakeConsequence: .lightBrake),
            FuzzyRule(speedCondition: .slow, distanceCondition: .medium, brakeConsequence: .noBrake),
            FuzzyRule(speedCondition: .slow, distanceCondition: .far, brakeConsequence: .noBrake),
            
            FuzzyRule(speedCondition: .moderate, distanceCondition: .veryNear, brakeConsequence: .strongBrake),
            FuzzyRule(speedCondition: .moderate, distanceCondition: .near, brakeConsequence: .moderateBrake),
            FuzzyRule(speedCondition: .moderate, distanceCondition: .medium, brakeConsequence: .lightBrake),
            FuzzyRule(speedCondition: .moderate, distanceCondition: .far, brakeConsequence: .noBrake),
            
            FuzzyRule(speedCondition: .fast, distanceCondition: .veryNear, brakeConsequence: .emergencyBrake),
            FuzzyRule(speedCondition: .fast, distanceCondition: .near, brakeConsequence: .strongBrake),
            FuzzyRule(speedCondition: .fast, distanceCondition: .medium, brakeConsequence: .moderateBrake),
            FuzzyRule(speedCondition: .fast, distanceCondition: .far, brakeConsequence: .lightBrake),
            
            FuzzyRule(speedCondition: .veryFast, distanceCondition: .veryNear, brakeConsequence: .emergencyBrake),
            FuzzyRule(speedCondition: .veryFast, distanceCondition: .near, brakeConsequence: .emergencyBrake),
            FuzzyRule(speedCondition: .veryFast, distanceCondition: .medium, brakeConsequence: .strongBrake),
            FuzzyRule(speedCondition: .veryFast, distanceCondition: .far, brakeConsequence: .moderateBrake)
        ]
    }
    
    // Fuzzification: Convert crisp inputs to fuzzy membership degrees
    func fuzzify(speed: Double, distance: Double) -> ([SpeedVariable: Double], [DistanceVariable: Double]) {
        var speedMemberships: [SpeedVariable: Double] = [:]
        var distanceMemberships: [DistanceVariable: Double] = [:]
        
        // Calculate speed memberships
        for (variable, function) in speedFunctions {
            let degree = function.membershipDegree(for: speed)
            if degree > 0 {
                speedMemberships[variable] = degree
            }
        }
        
        // Calculate distance memberships
        for (variable, function) in distanceFunctions {
            let degree = function.membershipDegree(for: distance)
            if degree > 0 {
                distanceMemberships[variable] = degree
            }
        }
        
        return (speedMemberships, distanceMemberships)
    }
    
    // Apply rules and determine brake intensity
    func inferBrakeIntensity(speed: Double, distance: Double) -> (Double, [FuzzyRule]) {
        let (speedMemberships, distanceMemberships) = fuzzify(speed: speed, distance: distance)
        var brakeOutputs: [BrakeVariable: Double] = [:]
        var activatedRules: [FuzzyRule] = []
        
        // Apply each rule
        for rule in rules where rule.isActive {
            let (brakeVar, activation) = rule.evaluate(speedMemberships: speedMemberships, distanceMemberships: distanceMemberships)
            
            if activation > 0 {
                // Store the max activation for each brake variable (applying OR operator for rules with same consequence)
                brakeOutputs[brakeVar] = max(brakeOutputs[brakeVar] ?? 0, activation)
                activatedRules.append(rule)
            }
        }
        
        // Defuzzification using weighted average (centroid) method
        let totalActivation = brakeOutputs.values.reduce(0, +)
        
        if totalActivation == 0 {
            self.activeRules = []
            return (0, [])
        }
        
        var weightedSum = 0.0
        
        for (brakeVar, activation) in brakeOutputs {
            guard let function = brakeFunctions[brakeVar] else { continue }
            
            // Use the middle point of the membership function as its representative value
            let centroid: Double
            switch function.type {
            case .triangular:
                centroid = function.points[1] // b is the peak
            case .trapezoidal:
                centroid = (function.points[1] + function.points[2]) / 2 // midpoint of b and c
            }
            
            weightedSum += centroid * activation
        }
        
        let defuzzifiedValue = weightedSum / totalActivation
        self.activeRules = activatedRules
        
        return (defuzzifiedValue, activatedRules)
    }
    
    // Update membership function parameters
    func updateMembershipFunction(for speedVar: SpeedVariable, with points: [Double]) {
        if var function = speedFunctions[speedVar] {
            function.points = points
            speedFunctions[speedVar] = function
        }
    }
    
    func updateMembershipFunction(for distanceVar: DistanceVariable, with points: [Double]) {
        if var function = distanceFunctions[distanceVar] {
            function.points = points
            distanceFunctions[distanceVar] = function
        }
    }
    
    func updateMembershipFunction(for brakeVar: BrakeVariable, with points: [Double]) {
        if var function = brakeFunctions[brakeVar] {
            function.points = points
            brakeFunctions[brakeVar] = function
        }
    }
} 
