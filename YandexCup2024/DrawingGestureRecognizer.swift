//
//  DrawingGestureRecognizer.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 29.10.2024.
//

import SwiftUI

struct Stroke {
    var color: Color
    var points: [CGPoint]
    var type: ToolType
}

class DrawingView: UIView {
    var selectedColor: Color
    var selectedTool: ToolType
    
    private let gestureRecognizer = DrawingGestureRecognizer()
    
    init(selectedColor: Color, selectedTool: ToolType) {
        self.selectedColor = selectedColor
        self.selectedTool = selectedTool
        
        super.init(frame: .zero)
        
        isOpaque = false
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        if let stroke = gestureRecognizer.stroke, let firstPoint = stroke.points.first {
            let path = UIBezierPath()
            path.move(to: firstPoint)
            
            switch stroke.type {
            case .pencil:
                path.lineWidth = 1
            case .brush:
                path.lineWidth = 15
            case .eraser:
                break
            }
            
            for i in 1..<stroke.points.count {
                path.addLine(to: stroke.points[i])
            }
            UIColor(stroke.color).setStroke()
            path.stroke()
        }
    }
}

struct DrawingViewRepresentable: UIViewRepresentable {
    @Binding var selectedColor: Color
    @Binding var selectedTool: ToolType
    
    func makeUIView(context: Context) -> DrawingView {
        .init(selectedColor: selectedColor, selectedTool: selectedTool)
    }
    
    func updateUIView(_ view: DrawingView, context: Context) {
        view.selectedColor = selectedColor
        view.selectedTool = selectedTool
    }
}

class DrawingGestureRecognizer: UIGestureRecognizer {
    var stroke: Stroke?
    
    var drawingView: DrawingView? {
        view as? DrawingView
    }
    
    private func append(_ touches: Set<UITouch>) {
        guard let touch = touches.first?.preciseLocation(in: drawingView) else {
            return
        }
        
        stroke?.points.append(touch)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let drawingView else { return }
        
        stroke = Stroke(
            color: drawingView.selectedColor,
            points: [],
            type: drawingView.selectedTool
        )
        
        append(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if numberOfTouches == 1 {
            append(touches)
        } else {
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        append(touches)
        drawingView?.setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        append(touches)
    }
}
