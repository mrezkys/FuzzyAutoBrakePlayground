//
//  RuleEditor.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct RuleEditor: View {
    @ObservedObject var model: SimulationEngine
    @State private var selectedRuleIndex: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Fuzzy Rules Configuration")
                    .font(.headline)
                Spacer()
                
                Button(action: {
                    // Reset to default rules
                    model.fuzzyEngine.setupDefaultRules()
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
            }
            
            List {
                ForEach(0..<model.fuzzyEngine.rules.count, id: \.self) { index in
                    let rule = model.fuzzyEngine.rules[index]
                    HStack {
                        Toggle("", isOn: Binding(
                            get: { rule.isActive },
                            set: { newValue in
                                model.fuzzyEngine.rules[index].isActive = newValue
                            }
                        ))
                        .labelsHidden()
                        
                        Text("IF")
                            .bold()
                        
                        Text("\(rule.speedCondition.rawValue)")
                            .foregroundColor(.blue)
                        
                        Text("AND")
                            .bold()
                        
                        Text("\(rule.distanceCondition.rawValue)")
                            .foregroundColor(.green)
                        
                        Text("THEN")
                            .bold()
                        
                        Text("\(rule.brakeConsequence.rawValue)")
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedRuleIndex = index
                        }) {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                    .background(model.activeRules.contains(where: { $0.id == rule.id }) ? Color.yellow.opacity(0.3) : Color.clear)
                    .cornerRadius(5)
                }
            }
            .frame(height: 200)
            
            Button(action: {
                // Add a new rule with default values
                let newRule = FuzzyRule(
                    speedCondition: .moderate,
                    distanceCondition: .medium,
                    brakeConsequence: .moderateBrake
                )
                model.fuzzyEngine.rules.append(newRule)
                selectedRuleIndex = model.fuzzyEngine.rules.count - 1
            }) {
                Label("Add Rule", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .sheet(item: Binding(
            get: { selectedRuleIndex.map { RuleEditorItem(index: $0) } },
            set: { selectedRuleIndex = $0?.index }
        )) { item in
            RuleEditorSheet(
                rule: $model.fuzzyEngine.rules[item.index],
                onDismiss: { selectedRuleIndex = nil }
            )
        }
    }
}

struct RuleEditorItem: Identifiable {
    var id: Int { index }
    let index: Int
}

struct RuleEditorSheet: View {
    @Binding var rule: FuzzyRule
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("IF Speed is")) {
                    Picker("Speed", selection: $rule.speedCondition) {
                        ForEach(SpeedVariable.allCases) { variable in
                            Text(variable.rawValue).tag(variable)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("AND Distance is")) {
                    Picker("Distance", selection: $rule.distanceCondition) {
                        ForEach(DistanceVariable.allCases) { variable in
                            Text(variable.rawValue).tag(variable)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("THEN Apply")) {
                    Picker("Brake", selection: $rule.brakeConsequence) {
                        ForEach(BrakeVariable.allCases) { variable in
                            Text(variable.rawValue).tag(variable)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Edit Rule")
            .navigationBarItems(
                leading: Button("Cancel") { onDismiss() },
                trailing: Button("Save") { onDismiss() }
            )
        }
    }
}
