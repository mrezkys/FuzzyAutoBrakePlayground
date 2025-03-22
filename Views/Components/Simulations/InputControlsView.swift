//
//  InputControlsView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct InputControlsView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Input Controls")
                .font(.headline)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Car Speed:")
                        .frame(width: 120, alignment: .leading)
                    
                    Slider(value: $model.carSpeed, in: 0...200, step: 1)
                    
                    TextField("Speed", value: $model.carSpeed, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                    
                    Text("km/h")
                        .frame(width: 40)
                }
                
                HStack {
                    Text("Distance:")
                        .frame(width: 120, alignment: .leading)
                    
                    Slider(
                        value: Binding(
                            get: { model.distanceToObstacle },
                            set: { model.setDistanceToObstacle($0) }
                        ),
                        in: 0...150, 
                        step: 1
                    )
                    
                    TextField("Distance", value: $model.distanceToObstacle, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                        .onChange(of: model.distanceToObstacle) { newValue in
                            model.setDistanceToObstacle(newValue)
                        }
                    
                    Text("m")
                        .frame(width: 40)
                }
                
                // Quick simulation scenarios
                HStack {
                    Text("Scenarios:")
                        .frame(width: 120, alignment: .leading)
                    
                    Button("Near & Fast") {
                        model.stopSimulation()
                        model.carSpeed = 100
                        model.setDistanceToObstacle(20)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Far & Slow") {
                        model.stopSimulation()
                        model.carSpeed = 40
                        model.setDistanceToObstacle(100)
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Emergency") {
                        model.stopSimulation()
                        model.carSpeed = 120
                        model.setDistanceToObstacle(10)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
    }
} 
