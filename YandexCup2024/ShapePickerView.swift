//
//  ShapePickerView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 29.10.2024.
//

import SwiftUI

enum ShapeType: Int, Identifiable, CaseIterable {
    case rectangle
    case circle
    case triangle
    case arrow
    
    var id: Int {
        rawValue
    }
    
    var icon: Image {
        switch self {
        case .rectangle:
            .init(.rectangle)
        case .circle:
            .init(.circle)
        case .triangle:
            .init(.triangle)
        case .arrow:
            .init(.arrow)
        }
    }
}

struct ShapePickerView: View {
    var body: some View {
        HStack(spacing: 16) {
            ForEach(ShapeType.allCases) { shape in
                shape.icon
                    .frame(width: 32, height: 32)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(4)
    }
}

#Preview {
    ShapePickerView()
}
