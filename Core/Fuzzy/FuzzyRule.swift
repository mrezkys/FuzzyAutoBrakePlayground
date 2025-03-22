//
//  FuzzyRule.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import Foundation

// Fuzzy rule representation
struct FuzzyRule: Identifiable {
    var id = UUID()
    var speedCondition: SpeedVariable
    var distanceCondition: DistanceVariable
    var brakeConsequence: BrakeVariable
    var isActive: Bool = true
    
    // Evaluate the rule given speed and distance membership degrees
    func evaluate(speedMemberships: [SpeedVariable: Double], distanceMemberships: [DistanceVariable: Double]) -> (BrakeVariable, Double) {
        // Using AND operator (min)
        let speedDegree = speedMemberships[speedCondition] ?? 0
        let distanceDegree = distanceMemberships[distanceCondition] ?? 0
        let activationDegree = min(speedDegree, distanceDegree)
        
        return (brakeConsequence, activationDegree)
    }
}
