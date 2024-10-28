//
//  ContentView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import SwiftUI
import SwiftData

enum ToolType {
    case pencil
    case brush
    case eraser
}

enum PickerType {
    case color
    case shape
}

struct ContentView: View {
    @State var presentedPicker: PickerType?
    @State var selectedTool: ToolType?
    
    private func undo() {
        
    }
    
    private func redo() {
        
    }
    
    private func deleteFrame() {
        
    }
    
    private func createNewFrame() {
        
    }
    
    private func openFramesList() {
        
    }
    
    private func playAnimation() {
        
    }
    
    private func pauseAnimation() {
        
    }
    
    private func openPresetShapes() {
        withAnimation {
            presentedPicker = .shape
        }
    }
    
    private func activatePencil() {
        withAnimation {
            selectedTool = .pencil
        }
    }
    
    private func activateBrush() {
        withAnimation {
            selectedTool = .brush
        }
    }
    
    private func activateEraser() {
        withAnimation {
            selectedTool = .eraser
        }
    }
    
    private func openColorPicker() {
        withAnimation {
            presentedPicker = .color
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button(action: undo, label: {
                    Image(.arrowLeft)
                })
                Button(action: redo, label: {
                    Image(.arrowRight)
                })
                Spacer()
                Button(action: deleteFrame, label: {
                    Image(.deleteFrame)
                })
                Button(action: createNewFrame, label: {
                    Image(.newFrame)
                })
                Button(action: openFramesList, label: {
                    Image(.frames)
                })
                Spacer()
                Button(action: pauseAnimation, label: {
                    Image(.pause)
                })
                Button(action: playAnimation, label: {
                    Image(.play)
                })
            }
            ZStack(alignment: .bottom) {
                Canvas { _, _ in
                    
                }
                .background(Image(.canvasBackground))
                .cornerRadius(20)
                
                switch presentedPicker {
                case .color:
                    ColorPickerView()
                case .shape:
                    ShapePickerView()
                case nil:
                    EmptyView()
                }
            }
            HStack(spacing: 16) {
                Button(action: activatePencil, label: {
                    Image(.pencil)
                        .renderingMode(.template)
                        .foregroundColor(selectedTool == .pencil ? .selection : .white)
                })
                Button(action: activateBrush, label: {
                    Image(.brush)
                        .renderingMode(.template)
                        .foregroundColor(selectedTool == .brush ? .selection : .white)
                })
                Button(action: activateEraser, label: {
                    Image(.erase)
                        .renderingMode(.template)
                        .foregroundColor(selectedTool == .eraser ? .selection : .white)
                })
                Button(action: openPresetShapes, label: {
                    Image(.presetShape)
                        .renderingMode(.template)
                        .foregroundColor(presentedPicker == .shape ? .selection : .white)
                })
                Button(action: openColorPicker, label: {
                    Circle()
                        .fill(.blue)
                        .stroke(presentedPicker == .color ? .selection : .clear)
                        .frame(width: 28, height: 28)
                })
            }
        }
        .padding(16.25)
        .background(.black)
        .colorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
