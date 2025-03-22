//
//  MembershipFunctionGraph.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct MembershipFunctionGraph<T: RawRepresentable & CaseIterable & Identifiable & Hashable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    @ObservedObject var model: SimulationEngine
    let variableType: String // "Speed", "Distance", or "Brake"
    let currentValue: Double?
    let maxValue: Double
    
    private func getFunction(for variable: T) -> MembershipFunction? {
        switch variableType {
        case "Speed":
            return model.fuzzyEngine.speedFunctions[variable as! SpeedVariable]
        case "Distance":
            return model.fuzzyEngine.distanceFunctions[variable as! DistanceVariable]
        case "Brake":
            return model.fuzzyEngine.brakeFunctions[variable as! BrakeVariable]
        default:
            return nil
        }
    }
    
    private func membershipDegree(for variable: T, at value: Double) -> Double? {
        guard let function = getFunction(for: variable) else { return nil }
        return function.membershipDegree(for: value)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                VStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        Divider()
                        Spacer()
                    }
                    Divider()
                }
                
                HStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        Divider()
                        Spacer()
                    }
                    Divider()
                }
                
                // X-axis
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // Y-axis
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // Membership functions
                ForEach(Array(T.allCases), id: \.self) { variable in
                    membershipFunctionPath(
                        for: variable,
                        in: geometry.size,
                        color: variableColor(for: variable)
                    )
                }
                
                // Current value indicator
                if let value = currentValue {
                    let x = CGFloat(value) / CGFloat(maxValue) * geometry.size.width
                    Path { path in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    .stroke(Color.black, lineWidth: 1.5)
                    
                    // Display membership degrees at current value
                    VStack(alignment: .leading) {
                        ForEach(Array(T.allCases), id: \.self) { variable in
                            if let degree = membershipDegree(for: variable, at: value), degree > 0 {
                                HStack {
                                    Circle()
                                        .fill(variableColor(for: variable))
                                        .frame(width: 8, height: 8)
                                    Text("\(variable.rawValue): \(Int(degree * 100))%")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(4)
                    .offset(x: x + 5, y: 5)
                }
            }
        }
        .overlay(
            Rectangle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
    
    private func membershipFunctionPath(for variable: T, in size: CGSize, color: Color) -> some View {
        guard let function = getFunction(for: variable) else { return AnyView(EmptyView()) }
        
        return AnyView(
            Path { path in
                let stepCount = 100
                let stepSize = maxValue / Double(stepCount) 
                
                var startPoint = true
                
                for i in 0...stepCount {
                    let x = Double(i) * stepSize
                    let normalizedX = CGFloat(x / maxValue)
                    let membership = function.membershipDegree(for: x)
                    let normalizedY = CGFloat(1 - membership)
                    
                    let point = CGPoint(
                        x: normalizedX * size.width,
                        y: normalizedY * size.height
                    )
                    
                    if startPoint {
                        path.move(to: point)
                        startPoint = false
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(color, lineWidth: 2)
        )
    }
    
    private func variableColor(for variable: T) -> Color {
        switch variable.rawValue {
        case "Slow", "Very Near", "No Brake":
            return .blue
        case "Moderate", "Near", "Light Brake":
            return .green
        case "Fast", "Medium", "Moderate Brake":
            return .orange
        case "Very Fast", "Far", "Strong Brake":
            return .red
        case "Emergency Brake":
            return .purple
        default:
            return .gray
        }
    }
}

