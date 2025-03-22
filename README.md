# FuzzyAutoBrakePlayground

## About This Project
FuzzyAutoBrakePlayground is an interactive SwiftUI application that demonstrates a fuzzy logic-based automotive braking system. The project simulates how a car's automatic braking system can use fuzzy logic to determine appropriate braking intensity based on variables like vehicle speed and distance to obstacles.

### Motivation
I created this project to dive deeper into fuzzy logic beyond what I learned in class. It's a fun way to see how the theory works in real life, letting me play around with different settings and see the results instantly. This hands-on approach helps me understand the concepts better and explore new ideas in a practical, engaging way.

## Screenshots
![Simulator Screenshot - iPad Pro 13-inch (M4) - 2025-03-23 at 02 36 51](https://github.com/user-attachments/assets/2179070d-9f70-487a-a4db-3f2d19cb1f30)
![Simulator Screenshot - iPad Pro 13-inch (M4) - 2025-03-23 at 02 37 02](https://github.com/user-attachments/assets/bdcdf4c7-ce75-4e59-b922-51fb25167fa7)

## Theory Explanation


### Fuzzy Logic in Automotive Systems
Fuzzy logic provides a way to handle imprecise data and make decisions based on "degrees of truth" rather than the strict true/false values of classical logic. In automotive braking systems, fuzzy logic can help create more natural and smooth braking behaviors that mimic human decision-making.

### Key Components:
1. **Fuzzy Variables**: The system uses three main variables:
   - **Speed**: The current vehicle speed
   - **Distance**: Distance to the obstacle ahead
   - **Brake**: The output variable representing braking intensity

2. **Membership Functions**: Each variable has multiple membership functions that describe linguistic terms (e.g., "slow," "medium," "fast" for speed).

3. **Fuzzy Rules**: Rules that connect input variables to outputs (e.g., "If speed is fast AND distance is close, THEN brake is hard").

4. **Defuzzification**: The process of converting fuzzy output values into a precise braking intensity value.

## Folder Structure

### Main Components:
- **Core/**: Contains the core functionality of the application
  - **Fuzzy/**: Implements the fuzzy logic system
    - `FuzzyVariable.swift`: Defines fuzzy variables and their properties
    - `FuzzyMembershipFunction.swift`: Implements different membership function shapes
    - `FuzzyRule.swift`: Defines the structure for fuzzy inference rules
    - `FuzzyLogicEngine.swift`: Main engine that processes rules and calculates outputs
  - **Simulation/**: Contains the simulation logic
    - `SimulationEngine.swift`: Manages the simulation state and controls

- **Views**: Contains UI components
  - **Components**: Reusable UI elements
    - **Fuzzy**: UI for fuzzy logic visualization and configuration
    - **Simulations**: Components for the simulation view
    - **Objects**: Visual elements for the simulation

- **MyApp.swift**: The application entry point
- **ContentView.swift**: The main view of the application

## How to Use
The playground interface allows you to:
1. Adjust vehicle speed and distance to obstacles
2. Modify membership functions for each variable
3. Create and edit fuzzy inference rules
4. Choose different defuzzification methods
5. Observe the resulting brake intensity in real-time simulation
