//
//  FuzzyMembershipFunction.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import Foundation

// Membership function types
enum MembershipFunctionType {
    case triangular
    case trapezoidal
}

// Membership function representation
struct MembershipFunction: Identifiable, Equatable {
    var id = UUID()
    var type: MembershipFunctionType
    var name: String
    var points: [Double] // For triangular: [a, b, c], trapezoidal: [a, b, c, d]
    
    // Calculate membership degree for a given input value
    func membershipDegree(for value: Double) -> Double {
        switch type {
        case .triangular:
            guard points.count >= 3 else { return 0 }
            let a = points[0]
            let b = points[1]
            let c = points[2]
            
            if value <= a || value >= c {
                return 0
            } else if value == b {
                return 1
            } else if value > a && value < b {
                return (value - a) / (b - a)
            } else { // value > b && value < c
                return (c - value) / (c - b)
            }
            
        case .trapezoidal:
            guard points.count >= 4 else { return 0 }
            let a = points[0]
            let b = points[1]
            let c = points[2]
            let d = points[3]
            
            if value <= a || value >= d {
                return 0
            } else if value >= b && value <= c {
                return 1
            } else if value > a && value < b {
                return (value - a) / (b - a)
            } else { // value > c && value < d
                return (d - value) / (d - c)
            }
        }
    }
}
