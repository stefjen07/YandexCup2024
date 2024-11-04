//
//  ToolType.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import SwiftUI

enum ToolType: Identifiable, Equatable {
    case pencil
    case brush
    case eraser
    case shape(ShapeType)
    
    var id: Int {
        switch self {
        case .pencil:
            0
        case .brush:
            1
        case .eraser:
            2
        case .shape(let shapeType):
            3 + shapeType.rawValue
        }
    }
    
    var icon: Image {
        switch self {
        case .pencil:
            .init(.pencil)
        case .brush:
            .init(.brush)
        case .eraser:
            .init(.erase)
        case .shape(let shapeType):
            shapeType.icon
        }
    }
}
