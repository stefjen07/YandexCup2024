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

enum PickerType {
    case color
    case shape
    case frame
}

struct SessionView: View {
    @State var presentedPicker: PickerType?
    @State var sharedItem: URL?
    
    @ObservedObject var session: DrawingSession
    @ObservedObject var currentLayer: DrawingLayer
    
    @State var layerRemovingStrategy: LayerRemovingStrategy?
    
    private func openFramesList() {
        withAnimation {
            presentedPicker = presentedPicker == .frame ? .none : .frame
        }
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
    
    private var isShapeSelected: Bool {
        if case .shape(_) = session.selectedTool {
            return true
        }
        
        return false
    }
    
    @ViewBuilder
    private var header: some View {
        HStack(spacing: 16) {
            if !session.isPlaying {
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
                        .foregroundColor(presentedPicker == .frame ? .selection : .primary)
                })
            }
            
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
                Stepper("Pencil width: \(session.pencilWidth)", value: $session.pencilWidth, in: 1...5)
                Stepper("Brush width: \(session.brushWidth)", value: $session.brushWidth, in: 10...25)
                Stepper("Shape width: \(session.shapeWidth)", value: $session.shapeWidth, in: 1...15)
                Stepper("\(session.fps) fps", value: $session.fps, in: 1...60)
            }, label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundColor(.primary)
            })
            
            Spacer()
            
            ForEach([ToolType.pencil, .brush, .eraser]) { tool in
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
                    .foregroundColor(presentedPicker == .shape || isShapeSelected ? .selection : .primary)
            })
            
            Button(action: openColorPicker, label: {
                Circle()
                    .fill(session.selectedColor)
                    .stroke(presentedPicker == .color ? .selection : .clear)
                    .frame(width: 28, height: 28)
            })
            
            Spacer()
            
            Button(action: {
                sharedItem = session.export()
            }, label: {
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
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 16.25)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                        if value.translation.width > 0 {
                            session.goPreviousLayer()
                        }
                    })
                
                ZStack(alignment: .bottom) {
                    DrawingViewRepresentable(session: session)
                        .disabled(session.isPlaying)
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
                        ShapePickerView(selectedTool: $session.selectedTool)
                    case .frame:
                        FramesView(
                            session: session,
                            isPresented: .init(get: {
                                presentedPicker == .frame
                            }, set: {
                                presentedPicker = $0 ? .frame : nil
                            })
                        )
                    case nil:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(width: 16.25)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                        if value.translation.width < 0 {
                            session.goNextLayer()
                        }
                    })
            }
            .padding(.horizontal, -16.25)
            
            HStack {
                Spacer()
                Text(session.layerIndexText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                value.translation.width > 0 ? session.goPreviousLayer() : session.goNextLayer()
            })
            
            footer
                .opacity(session.isPlaying ? 0 : 1)
        }
        .padding(16.25)
        .sheet(item: $sharedItem) { url in
            ActivityView(activityItems: [url])
        }
    }
}
