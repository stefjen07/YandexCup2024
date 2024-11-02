//
//  DrawingSession.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import SwiftUI
import Combine

class DrawingSession: ObservableObject {
    @Published var selectedColor: Color
    @Published var selectedTool: ToolType
    private var layers: [DrawingLayer] = [.init()]
    
    private var currentLayerCancellable: AnyCancellable?
    @Published private var currentLayerIndex = 0 {
        didSet {
            currentLayerCancellable = currentLayer.objectWillChange.sink { [weak self] in
                self?.drawingView?.setNeedsDisplay()
            }
        }
    }
    
    weak var drawingView: UIView?
    
    init(selectedColor: Color, selectedTool: ToolType) {
        self.selectedColor = selectedColor
        self.selectedTool = selectedTool
    }
    
    var currentLayer: DrawingLayer {
        layers[currentLayerIndex]
    }
    
    func addLayer() {
        layers.insert(.init(), at: currentLayerIndex + 1)
        currentLayerIndex += 1
    }
    
    func removeLayer() {
        layers.remove(at: currentLayerIndex)
        
        if currentLayerIndex > 0 {
            currentLayerIndex -= 1
        } else {
            layers.append(DrawingLayer())
            drawingView?.setNeedsDisplay()
        }
    }
}
