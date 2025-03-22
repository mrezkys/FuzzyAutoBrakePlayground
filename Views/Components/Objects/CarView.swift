//
//  CarView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct CarView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        ZStack {
            // Car body
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
                .frame(width: model.carWidth, height: model.carHeight)
            
            // Car windows
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.cyan.opacity(0.7))
                .frame(width: model.carWidth * 0.6, height: model.carHeight * 0.5)
                .offset(x: model.carWidth * 0.05)
            
            // Wheels
            HStack(spacing: model.carWidth * 0.5) {
                VStack(spacing: model.carHeight * 0.7) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                }
                
                VStack(spacing: model.carHeight * 0.7) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width: 12, height: 12)
                }
            }
            
            // Brake lights (active when braking)
            HStack(spacing: 10) {
                Rectangle()
                    .fill(model.brakeIntensity > 0 ? Color.red : Color.red.opacity(0.2))
                    .frame(width: 5, height: 8)
                
                Rectangle()
                    .fill(model.brakeIntensity > 0 ? Color.red : Color.red.opacity(0.2))
                    .frame(width: 5, height: 8)
            }
            .offset(x: -model.carWidth * 0.4, y: 0)
        }
    }
}
