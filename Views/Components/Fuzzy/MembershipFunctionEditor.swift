//
//  MembershipFunctionEditor.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct MembershipFunctionEditor<T: RawRepresentable & CaseIterable & Identifiable & Hashable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    @ObservedObject var model: SimulationEngine
    let variableType: String // "Speed", "Distance", or "Brake"
    @State private var selectedVariable: T?
    @State private var editedPoints: [Double] = []
    
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
    
    private func updateFunction() {
        guard let variable = selectedVariable else { return }
        
        switch variableType {
        case "Speed":
            model.fuzzyEngine.updateMembershipFunction(for: variable as! SpeedVariable, with: editedPoints)
        case "Distance":
            model.fuzzyEngine.updateMembershipFunction(for: variable as! DistanceVariable, with: editedPoints)
        case "Brake":
            model.fuzzyEngine.updateMembershipFunction(for: variable as! BrakeVariable, with: editedPoints)
        default:
            break
        }
        
        model.objectWillChange.send()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edit \(variableType) Membership Functions")
                    .font(.headline)
                Spacer()
            }
            
            // Variable selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(T.allCases), id: \.self) { variable in
                        Button(action: {
                            selectedVariable = variable
                            if let function = getFunction(for: variable) {
                                editedPoints = function.points
                            }
                        }) {
                            Text(variable.rawValue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(selectedVariable == variable ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(selectedVariable == variable ? .white : .primary)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .padding(.vertical, 5)
            
            if let variable = selectedVariable, let function = getFunction(for: variable) {
                VStack {
                    // Point editors
                    ForEach(0..<editedPoints.count, id: \.self) { index in
                        HStack {
                            Text(pointLabel(for: function.type, at: index))
                                .frame(width: 80, alignment: .leading)
                            
                            TextField("Value", value: $editedPoints[index], formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Slider(value: $editedPoints[index], in: 0...maxValue())
                                .onChange(of: editedPoints[index]) { _ in
                                    validatePoints()
                                    updateFunction()
                                }
                        }
                    }
                    
                    // Preview
                    MembershipFunctionGraph<T>(
                        model: model,
                        variableType: variableType,
                        currentValue: nil,
                        maxValue: maxValue()
                    )
                    .frame(height: 100)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            } else {
                Text("Select a variable to edit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
    
    private func pointLabel(for type: MembershipFunctionType, at index: Int) -> String {
        switch type {
        case .triangular:
            switch index {
            case 0: return "Left (a)"
            case 1: return "Peak (b)"
            case 2: return "Right (c)"
            default: return "Point \(index)"
            }
        case .trapezoidal:
            switch index {
            case 0: return "Left (a)"
            case 1: return "Top Left (b)"
            case 2: return "Top Right (c)"
            case 3: return "Right (d)"
            default: return "Point \(index)"
            }
        }
    }
    
    private func maxValue() -> Double {
        switch variableType {
        case "Speed": return 200.0
        case "Distance": return 150.0
        case "Brake": return 100.0
        default: return 100.0
        }
    }
    
    private func validatePoints() {
        // Ensure points are in ascending order
        for i in 1..<editedPoints.count {
            if editedPoints[i] < editedPoints[i-1] {
                editedPoints[i] = editedPoints[i-1]
            }
        }
    }
}
