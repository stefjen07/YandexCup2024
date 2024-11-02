//
//  ContentView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import SwiftUI
import SwiftData

enum ToolType: Int, Identifiable, CaseIterable {
    case pencil
    case brush
    case eraser
    
    var id: Int {
        rawValue
    }
    
    var icon: Image {
        switch self {
        case .pencil:
            .init(.pencil)
        case .brush:
            .init(.brush)
        case .eraser:
            .init(.erase)
        }
    }
}

enum PickerType {
    case color
    case shape
}

struct ContentView: View {
    @State var presentedPicker: PickerType?
    
    @ObservedObject var session: DrawingSession = .init(selectedColor: .blue, selectedTool: .pencil)
    
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
        
    }
    
    private func activateBrush() {
        withAnimation {
            session.selectedTool = .brush
        }
    }
    
    private func activateEraser() {
        withAnimation {
            session.selectedTool = .eraser
        }
    }
    
    private func openColorPicker() {
        withAnimation {
            presentedPicker = .color
        }
    }
    
    @ViewBuilder
    private var header: some View {
        HStack(spacing: 16) {
            Button(action: session.currentLayer.undo, label: {
                Image(.arrowLeft)
            })
            .disabled(session.currentLayer.isUndoDisabled)
            Button(action: session.currentLayer.redo, label: {
                Image(.arrowRight)
            })
            .disabled(session.currentLayer.isRedoDisabled)
            Spacer()
            Button(action: session.removeLayer, label: {
                Image(.deleteFrame)
            })
            Button(action: session.addLayer, label: {
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
    }
    
    private var footer: some View {
        HStack(spacing: 16) {
            ForEach(ToolType.allCases) { tool in
                Button(action: {
                    withAnimation {
                        session.selectedTool = tool
                    }
                }, label: {
                    tool.icon
                        .renderingMode(.template)
                        .foregroundColor(session.selectedTool == tool ? .selection : .white)
                })
            }
            
            Button(action: openPresetShapes, label: {
                Image(.presetShape)
                    .renderingMode(.template)
                    .foregroundColor(presentedPicker == .shape ? .selection : .white)
            })
            Button(action: openColorPicker, label: {
                Circle()
                    .fill(session.selectedColor)
                    .stroke(presentedPicker == .color ? .selection : .clear)
                    .frame(width: 28, height: 28)
            })
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            header
            
            ZStack(alignment: .bottom) {
                DrawingViewRepresentable(session: session)
                .background(Image(.canvasBackground))
                .cornerRadius(20)
                
                switch presentedPicker {
                case .color:
                    ColorPickerView(selectedColor: $session.selectedColor)
                case .shape:
                    ShapePickerView()
                case nil:
                    EmptyView()
                }
            }
            
            footer
        }
        .padding(16.25)
        .background(.black)
        .colorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
