//
//  DefuzzificationView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct DefuzzificationView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Defuzzification Result")
                .font(.headline)
            
            HStack(spacing: 20) {
                // Brake percentage indicator
                VStack {
                    Text("Brake Force")
                        .font(.subheadline)
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.3)
                            .foregroundColor(.red)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(model.brakeIntensity / 100, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.red)
                            .rotationEffect(Angle(degrees: 270.0))
                        
                        Text("\(Int(model.brakeIntensity))%")
                            .font(.title)
                            .bold()
                    }
                    .frame(width: 100, height: 100)
                }
                
                // Active rules
                VStack(alignment: .leading) {
                    Text("Active Rules:")
                        .font(.subheadline)
                    
                    if model.activeRules.isEmpty {
                        Text("None")
                            .italic()
                    } else {
                        ForEach(model.activeRules) { rule in
                            Text("• IF \(rule.speedCondition.rawValue) AND \(rule.distanceCondition.rawValue) THEN \(rule.brakeConsequence.rawValue)")
                                .font(.caption)
                        }
                    }
                }
            }
            
            // Graph of brake membership functions
            MembershipFunctionGraph<BrakeVariable>(
                model: model,
                variableType: "Brake",
                currentValue: model.brakeIntensity,
                maxValue: 100
            )
            .frame(height: 120)
            .padding(.top, 10)
        }
    }
} 
