//
//  ColorPickerView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 29.10.2024.
//

import SwiftUI

struct ColorPickerView: View {
    @State var isFullColorPickerPresented = false
    @Binding var selectedColor: Color
    
    var lastColors: [Color] = [.white, .red, .black, .blue]
    
    private func openFullColorPicker() {
        withAnimation {
            isFullColorPickerPresented.toggle()
        }
    }
    
    @ViewBuilder
    func cell(for color: Color) -> some View {
        Button(action: {
            withAnimation {
                selectedColor = color
            }
        }, label: {
            Circle()
                .fill(color)
                .stroke(selectedColor == color ? .selection : .clear)
                .frame(width: 32, height: 32)
        })
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if isFullColorPickerPresented {
                VStack(spacing: 16) {
                    ForEach(0..<5) { i in
                        HStack {
                            ForEach(0..<5) { j in
                                cell(for: Color(
                                    red: Double(i) / 4,
                                    green: Double(j) / 4,
                                    blue: Double(4 - i - j) / 4)
                                )
                                
                                if j != 4 {
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding(16)
                .frame(width: 280)
                .background(.ultraThinMaterial)
                .cornerRadius(4)
            }
            
            HStack(spacing: 16) {
                Button(action: openFullColorPicker, label: {
                    Image(.palette)
                        .renderingMode(.template)
                        .foregroundColor(isFullColorPickerPresented ? .selection : .white)
                })
                
                ForEach(0..<4) { i in
                    cell(for: lastColors[i])
                }
            }
            .padding(16)
            .frame(width: 280)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
        }
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.blue))
}
