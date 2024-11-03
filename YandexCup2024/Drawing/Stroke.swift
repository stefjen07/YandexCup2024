//
//  Stroke.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import SwiftUI

struct Stroke {
    var color: Color
    var points: [CGPoint]
    var width: CGFloat
    
    var path: UIBezierPath? {
        guard let firstPoint = points.first else {
            return nil
        }
        
        let path = UIBezierPath()
        path.lineWidth = width
        path.move(to: firstPoint)
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        return path
    }
}
