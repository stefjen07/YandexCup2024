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
    @Published var pencilWidth: Int = 1
    @Published var brushWidth: Int = 15
    @Published var shapeWidth: Int = 1
    @Published var fps: Int = 15
    private(set) var layers: [DrawingLayer] = [.init()]
    
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
    
    private let gifExporter = GIFExporter()
    var canvasSize: CGSize?
    
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
    
    func generateLayers(count: Int) {
        guard let canvasSize, count > 0 else { return }
        
        let newLayers = (0..<count).map { _ in
            let layer = DrawingLayer()
            let shapeSize: CGFloat = 50
            let startPoint = CGPoint(
                x: .random(in: 0..<canvasSize.width-shapeSize),
                y: .random(in: 0..<canvasSize.height-shapeSize)
            )
            let shape = Shape(
                type: .circle,
                startPoint: startPoint,
                endPoint: startPoint.applying(.init(translationX: shapeSize, y: shapeSize)),
                width: 1,
                color: .blue
            )
            layer.addShape(shape)
            return layer
        }
        
        layers.insert(contentsOf: newLayers, at: currentLayerIndex + 1)
        currentLayerIndex += count
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
    
    func selectLayer(_ index: Int) {
        guard (0..<layers.count).contains(index) else { return }
        currentLayerIndex = index
    }
    
    func play() {
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(fps), repeats: true) { [weak self] timer in
            guard let self else { return }
            
            if currentLayerIndex == layers.count - 1 {
                currentLayerIndex = 0
            } else {
                goNextLayer()
            }
        }
    }
    
    func pause() {
        isPlaying = false
        currentLayerIndex = layers.count - 1
        timer?.invalidate()
    }
    
    func export() -> URL? {
        guard let canvasSize else { return nil }
        return gifExporter.export(layers: layers, fps: fps, size: canvasSize)
    }
}
