//
//  DistanceIndicatorView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct DistanceIndicatorView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        ZStack {
            // Distance line
            Path { path in
                path.move(to: CGPoint(x: model.carPosition + model.carWidth, y: 50))
                path.addLine(to: CGPoint(x: model.obstaclePosition, y: 50))
                
                // Arrow at both ends
                let arrowLength: CGFloat = 10
                let arrowWidth: CGFloat = 5
                
                // Left arrow
                path.move(to: CGPoint(x: model.carPosition + model.carWidth + arrowLength, y: 50 - arrowWidth))
                path.addLine(to: CGPoint(x: model.carPosition + model.carWidth, y: 50))
                path.addLine(to: CGPoint(x: model.carPosition + model.carWidth + arrowLength, y: 50 + arrowWidth))
                
                // Right arrow
                path.move(to: CGPoint(x: model.obstaclePosition - arrowLength, y: 50 - arrowWidth))
                path.addLine(to: CGPoint(x: model.obstaclePosition, y: 50))
                path.addLine(to: CGPoint(x: model.obstaclePosition - arrowLength, y: 50 + arrowWidth))
            }
            .stroke(Color.black, lineWidth: 1)
            
            // Distance label
            Text("\(String(format: "%.1f", model.distanceToObstacle)) m")
                .font(.caption)
                .padding(4)
                .background(Color.white.opacity(0.7))
                .cornerRadius(4)
                .position(
                    x: (model.carPosition + model.carWidth + model.obstaclePosition) / 2,
                    y: 30
                )
        }
    }
}
