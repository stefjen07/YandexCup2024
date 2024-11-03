//
//  DrawingGestureRecognizer.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import UIKit

class DrawingGestureRecognizer: UIGestureRecognizer {
    var stroke: Stroke?
    private var lastPoint: CGPoint?
    
    private var drawingView: DrawingView? {
        view as? DrawingView
    }
    
    private func append(_ touches: Set<UITouch>) {
        guard let touch = touches.first?.preciseLocation(in: drawingView) else {
            return
        }
        
        stroke?.points.append(touch)
        drawingView?.setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let drawingView else { return }
        
        if drawingView.session.selectedTool == .eraser {
            lastPoint = touches.first?.preciseLocation(in: drawingView)
        } else {
            let width = switch drawingView.session.selectedTool {
            case .brush:
                drawingView.session.brushWidth
            case .pencil:
                drawingView.session.pencilWidth
            default:
                0
            }
            
            stroke = Stroke(
                color: drawingView.session.selectedColor,
                points: [],
                width: CGFloat(width)
            )
            
            append(touches)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if numberOfTouches == 1 {
            
            
            if let drawingView,
               let lastPoint,
               let newPoint = touches.first?.preciseLocation(in: drawingView),
               drawingView.session.selectedTool == .eraser
            {
                drawingView.session.currentLayer.eraseStrokes(byLine: (lastPoint, newPoint))
                self.lastPoint = newPoint
            } else {
                append(touches)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        append(touches)
        
        if let stroke {
            drawingView?.session.currentLayer.addStroke(stroke)
            self.stroke = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        append(touches)
    }
}
