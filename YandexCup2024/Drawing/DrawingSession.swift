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
    @Published var fps: Int = 15
    private var layers: [DrawingLayer] = [.init()]
    
    private var currentLayerCancellable: AnyCancellable?
    @Published private var currentLayerIndex = 0 {
        didSet {
            currentLayerCancellable = currentLayer.objectWillChange.sink { [weak self] in
                self?.drawingView?.setNeedsDisplay()
            }
            drawingView?.setNeedsDisplay()
        }
    }
    
    private var timer: Timer?
    @Published private(set) var isPlaying = false
    
    weak var drawingView: UIView?
    
    init(selectedColor: Color, selectedTool: ToolType) {
        self.selectedColor = selectedColor
        self.selectedTool = selectedTool
    }
    
    var currentLayer: DrawingLayer {
        layers[currentLayerIndex]
    }
    
    var layerIndexText: String {
        "\(currentLayerIndex+1) / \(layers.count)"
    }
    
    func addLayer() {
        layers.insert(.init(), at: currentLayerIndex + 1)
        currentLayerIndex += 1
    }
    
    func duplicateLayer() {
        addLayer()
        layers[currentLayerIndex-1].copyContent(to: currentLayer)
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
    
    func removeAllLayers() {
        layers = [.init()]
        currentLayerIndex = 0
    }
    
    func goPreviousLayer() {
        guard currentLayerIndex > 0 else { return }
        currentLayerIndex -= 1
    }
    
    func goNextLayer() {
        guard currentLayerIndex < layers.count - 1 else { return }
        currentLayerIndex += 1
    }
    
    func play() {
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(fps), repeats: true) { [weak self] timer in
            guard let self else { return }
            
            if currentLayerIndex == layers.count - 1 {
                isPlaying = false
                timer.invalidate()
            } else {
                goNextLayer()
            }
        }
    }
    
    func pause() {
        isPlaying = false
        timer?.invalidate()
    }
}
