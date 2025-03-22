//
//  FuzzyVariable.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import Foundation

// Linguistic variables for our fuzzy sets
enum SpeedVariable: String, CaseIterable, Identifiable, Hashable {
    case slow = "Slow"
    case moderate = "Moderate"
    case fast = "Fast"
    case veryFast = "Very Fast"
    
    var id: String { self.rawValue }
}

enum DistanceVariable: String, CaseIterable, Identifiable, Hashable {
    case veryNear = "Very Near"
    case near = "Near"
    case medium = "Medium"
    case far = "Far"
    
    var id: String { self.rawValue }
}

enum BrakeVariable: String, CaseIterable, Identifiable, Hashable {
    case noBrake = "No Brake"
    case lightBrake = "Light Brake"
    case moderateBrake = "Moderate Brake"
    case strongBrake = "Strong Brake"
    case emergencyBrake = "Emergency Brake"
    
    var id: String { self.rawValue }
}
