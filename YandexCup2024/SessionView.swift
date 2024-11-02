//
//  SessionView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import SwiftUI

enum LayerRemovingStrategy: Int, Identifiable {
    case current
    case all
    
    var id: Int {
        rawValue
    }
}

struct SessionView: View {
    @State var presentedPicker: PickerType?
    @ObservedObject var session: DrawingSession
    @ObservedObject var currentLayer: DrawingLayer
    
    @State var layerRemovingStrategy: LayerRemovingStrategy?
    
    private func openFramesList() {
        
    }
    
    private func openPresetShapes() {
        withAnimation {
            presentedPicker = presentedPicker == .shape ? .none : .shape
        }
    }
    
    private func openColorPicker() {
        withAnimation {
            presentedPicker = presentedPicker == .color ? .none : .color
        }
    }
    
    @ViewBuilder
    private var header: some View {
        HStack(spacing: 16) {
            Button(action: currentLayer.undo, label: {
                Image(.arrowLeft)
                    .renderingMode(.template)
            })
            .foregroundColor(currentLayer.isUndoDisabled ? .secondary : .primary)
            .disabled(currentLayer.isUndoDisabled)
            Button(action: currentLayer.redo, label: {
                Image(.arrowRight)
                    .renderingMode(.template)
            })
            .foregroundColor(currentLayer.isUndoDisabled ? .secondary : .primary)
            .disabled(currentLayer.isRedoDisabled)
            Spacer()
            Button(action: {
                layerRemovingStrategy = .current
            }, label: {
                Image(.deleteFrame)
                    .renderingMode(.template)
                    .foregroundColor(.red)
                    .cornerRadius(6)
            })
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 6))
            .contextMenu {
                VStack {
                    Button(action: {
                        layerRemovingStrategy = .current
                    }, label: {
                        Image(systemName: "1.square")
                        Text("Remove current layer")
                    })
                    
                    Button(action: {
                        layerRemovingStrategy = .all
                    }, label: {
                        Image(systemName: "square.grid.3x1.below.line.grid.1x2")
                        Text("Remove all layers")
                            .foregroundColor(.red)
                    })
                }
            }
            
            Button(action: session.addLayer, label: {
                Image(.newFrame)
                    .renderingMode(.template)
            })
            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 6))
            .contextMenu {
                VStack {
                    Button(action: session.addLayer, label: {
                        Image(systemName: "plus")
                        Text("Create new layer")
                    })
                    
                    Button(action: session.duplicateLayer, label: {
                        Image(systemName: "square.on.square")
                        Text("Duplicate current layer")
                    })
                }
                .foregroundColor(.red)
            }
            
            Button(action: openFramesList, label: {
                Image(.frames)
                    .renderingMode(.template)
            })
            Spacer()
            Button(action: session.pause, label: {
                Image(.pause)
                    .renderingMode(.template)
            })
            .foregroundColor(!session.isPlaying ? .secondary : .primary)
            .disabled(!session.isPlaying)
            Button(action: session.play, label: {
                Image(.play)
                    .renderingMode(.template)
            })
            .foregroundColor(session.isPlaying ? .secondary : .primary)
            .disabled(session.isPlaying)
        }
        .foregroundColor(.primary)
        .alert(item: $layerRemovingStrategy) { strategy in
            switch strategy {
            case .all:
                Alert(
                    title: Text("Do you want to remove all the layers?"),
                    primaryButton: .destructive(Text("Remove all"), action: session.removeAllLayers),
                    secondaryButton: .cancel()
                )
            case .current:
                Alert(
                    title: Text("Do you want to remove current layer?"),
                    primaryButton: .destructive(Text("Remove"), action: session.removeLayer),
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private var footer: some View {
        HStack(spacing: 16) {
            Menu(content: {
                Stepper("\(session.fps) fps", value: $session.fps, in: 1...60)
            }, label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundColor(.primary)
            })
            
            Spacer()
            
            ForEach(ToolType.allCases) { tool in
                Button(action: {
                    withAnimation {
                        session.selectedTool = tool
                    }
                }, label: {
                    tool.icon
                        .renderingMode(.template)
                        .foregroundColor(session.selectedTool == tool ? .selection : .primary)
                })
            }
            
            Button(action: openPresetShapes, label: {
                Image(.presetShape)
                    .renderingMode(.template)
                    .foregroundColor(presentedPicker == .shape ? .selection : .primary)
            })
            Button(action: openColorPicker, label: {
                Circle()
                    .fill(session.selectedColor)
                    .stroke(presentedPicker == .color ? .selection : .clear)
                    .frame(width: 28, height: 28)
            })
            
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundColor(.primary)
            })
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            header
            
            ZStack(alignment: .bottom) {
                DrawingViewRepresentable(session: session)
                    .background(
                        Image(.canvasBackground)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .cornerRadius(20)
                    .clipped()
                
                switch presentedPicker {
                case .color:
                    ColorPickerView(selectedColor: $session.selectedColor)
                case .shape:
                    ShapePickerView()
                case nil:
                    EmptyView()
                }
            }
            HStack {
                Spacer()
                Text(session.layerIndexText)
                Spacer()
            }
                .font(.caption)
                .foregroundStyle(.secondary)
                .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                    value.translation.width > 0 ? session.goPreviousLayer() : session.goNextLayer()
                })
            
            footer
        }
        .padding(16.25)
    }
}
