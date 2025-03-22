//
//  ObstacleView.swift
//  FuzzyPlayground
//
//  Created by Muhammad Rezky on 21/03/25.
//

import SwiftUI

struct ObstacleView: View {
    @ObservedObject var model: SimulationEngine
    
    var body: some View {
        ZStack {
            // Obstacle (barrier)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.red)
                .frame(width: model.obstacleWidth, height: model.obstacleHeight)
            
            // Stripes
            VStack(spacing: 5) {
                ForEach(0..<3) { _ in
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: model.obstacleWidth * 0.8, height: 5)
                }
            }
        }
    }
}
