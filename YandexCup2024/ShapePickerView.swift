//
//  ShapePickerView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 29.10.2024.
//

import SwiftUI

struct ShapePickerView: View {
    @Binding var selectedTool: ToolType
    
    var selectedShape: ShapeType? {
        if case .shape(let shapeType) = selectedTool {
            return shapeType
        }
        
        return nil
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(ShapeType.allCases) { shape in
                Button(action: {
                    selectedTool = .shape(shape)
                }, label: {
                    shape.icon
                        .renderingMode(.template)
                        .foregroundColor(selectedShape == shape ? .selection : .primary)
                        .frame(width: 32, height: 32)
                })
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(4)
    }
}

#Preview {
    ShapePickerView(selectedTool: .constant(.brush))
}
