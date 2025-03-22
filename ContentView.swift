//
//  ContentView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var simulationEngine = SimulationEngine()
    @State private var selectedTabIndex = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Top part - Simulation View
                SimulationView(model: simulationEngine)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                
                // Input Controls
                InputControlsView(model: simulationEngine)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                
                // Bottom part - Tabbed Interface
                VStack {
                    // Tab selector
                    HStack {
                        TabButton(title: "Speed Functions", isSelected: selectedTabIndex == 0) {
                            selectedTabIndex = 0
                        }
                        
                        TabButton(title: "Distance Functions", isSelected: selectedTabIndex == 1) {
                            selectedTabIndex = 1
                        }
                        
                        TabButton(title: "Brake Functions", isSelected: selectedTabIndex == 2) {
                            selectedTabIndex = 2
                        }
                        
                        TabButton(title: "Rules", isSelected: selectedTabIndex == 3) {
                            selectedTabIndex = 3
                        }
                        
                        TabButton(title: "Defuzzification", isSelected: selectedTabIndex == 4) {
                            selectedTabIndex = 4
                        }
                    }
                    .padding(.horizontal)
                    
                    // Tab content
                    ScrollView {
                        VStack {
                            switch selectedTabIndex {
                            case 0:
                                VStack {
                                    // Speed membership function graph
                                    MembershipFunctionGraph<SpeedVariable>(
                                        model: simulationEngine,
                                        variableType: "Speed",
                                        currentValue: simulationEngine.carSpeed,
                                        maxValue: 200
                                    )
                                    .frame(height: 150)
                                    .padding()
                                    
                                    // Speed membership function editor
                                    MembershipFunctionEditor<SpeedVariable>(
                                        model: simulationEngine,
                                        variableType: "Speed"
                                    )
                                    .padding()
                                }
                                
                            case 1:
                                VStack {
                                    // Distance membership function graph
                                    MembershipFunctionGraph<DistanceVariable>(
                                        model: simulationEngine,
                                        variableType: "Distance",
                                        currentValue: simulationEngine.distanceToObstacle,
                                        maxValue: 150
                                    )
                                    .frame(height: 150)
                                    .padding()
                                    
                                    // Distance membership function editor
                                    MembershipFunctionEditor<DistanceVariable>(
                                        model: simulationEngine,
                                        variableType: "Distance"
                                    )
                                    .padding()
                                }
                                
                            case 2:
                                VStack {
                                    // Brake membership function graph
                                    MembershipFunctionGraph<BrakeVariable>(
                                        model: simulationEngine,
                                        variableType: "Brake",
                                        currentValue: simulationEngine.brakeIntensity,
                                        maxValue: 100
                                    )
                                    .frame(height: 150)
                                    .padding()
                                    
                                    // Brake membership function editor
                                    MembershipFunctionEditor<BrakeVariable>(
                                        model: simulationEngine,
                                        variableType: "Brake"
                                    )
                                    .padding()
                                }
                                
                            case 3:
                                RuleEditor(model: simulationEngine)
                                    .padding()
                                
                            case 4:
                                DefuzzificationView(model: simulationEngine)
                                    .padding()
                                
                            default:
                                EmptyView()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .padding(.vertical)
            .navigationTitle("Fuzzy Auto Brake System")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .navigationViewStyle(.stack)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                .foregroundColor(isSelected ? .blue : .primary)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
