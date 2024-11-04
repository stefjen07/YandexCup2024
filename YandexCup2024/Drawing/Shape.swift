//
//  Shape.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 04.11.2024.
//

import SwiftUI

enum ShapeType: Int, Identifiable, CaseIterable {
    case rectangle
    case circle
    
//TODO: Implement
//    case triangle
//    case arrow
    
    var id: Int {
        rawValue
    }
    
    var icon: Image {
        switch self {
        case .rectangle:
            .init(.rectangle)
        case .circle:
            .init(.circle)
//        case .triangle:
//            .init(.triangle)
//        case .arrow:
//            .init(.arrow)
        }
    }
}

struct Shape {
    var type: ShapeType
    var startPoint: CGPoint
    var endPoint: CGPoint
    var width: CGFloat
    var color: Color
    
    var rect: CGRect {
        .init(
            x: min(startPoint.x, endPoint.x),
            y: min(startPoint.y, endPoint.y),
            width: abs(startPoint.x - endPoint.x),
            height: abs(startPoint.y - endPoint.y)
        )
    }
    
    var path: CGPath {
        switch type {
        case .rectangle:
            .init(rect: rect, transform: nil)
        case .circle:
            .init(ellipseIn: rect, transform: nil)
        }
    }
}
