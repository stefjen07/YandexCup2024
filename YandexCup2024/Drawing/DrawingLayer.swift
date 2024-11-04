//
//  DrawingLayer.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import Foundation
import CoreGraphics
import UIKit

class DrawingLayer: ObservableObject, Identifiable {
    public let id = UUID()
    @Published private(set) var actions: [DrawingAction] = []
    private var undoActions: [DrawingAction] = []
    
    func copyContent(to layer: DrawingLayer) {
        layer.actions = actions
    }
    
    func addStroke(_ stroke: Stroke) {
        actions.append(.stroke(stroke))
        undoActions = []
    }
    
    func addShape(_ shape: Shape) {
        actions.append(.shape(shape))
        undoActions = []
    }
    
    func undo() {
        guard !actions.isEmpty else { return }
        undoActions.append(actions.removeLast())
    }
    
    func redo() {
        guard !undoActions.isEmpty else { return }
        actions.append(undoActions.removeFirst())
    }
    
    var isUndoDisabled: Bool {
        actions.isEmpty
    }
    
    var isRedoDisabled: Bool {
        undoActions.isEmpty
    }
    
    func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> Bool {
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            return false
        }

        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant
        let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

        return (0...1).contains(ab) && (0...1).contains(cd)
    }
    
    func eraseActions(byLine line: (CGPoint, CGPoint)) {
        var newActions: [DrawingAction] = []
        actions.forEach {
            switch $0 {
            case .stroke(let stroke):
                for i in 1..<stroke.points.count {
                    if linesCross(start1: line.0, end1: line.1, start2: stroke.points[i-1], end2: stroke.points[i]) {
                        undoActions.append($0)
                        return
                    }
                }
            case .shape(let shape):
                let rect = shape.rect
                switch shape.type {
                case .rectangle:
                    if rect.contains(line.1) {
                        undoActions.append($0)
                        return
                    }
                case .circle:
                    if line.1.distance(to: rect.center) <= rect.radius {
                        undoActions.append($0)
                        return
                    }
                }
            }
            newActions.append($0)
        }
        actions = newActions
    }
    
    func renderImage(size: CGSize, scale: CGFloat = 1) -> CGImage? {
        let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 4 * Int(size.width),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue |
            CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        )
        
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1, y: -1)
        
        for action in actions {
            switch action {
            case .stroke(let stroke):
                if let path = stroke.path {
                    context?.setStrokeColor(UIColor(stroke.color).cgColor)
                    context?.setLineWidth(path.lineWidth)
                    context?.addPath(path.cgPath)
                    context?.strokePath()
                }
            case .shape(let shape):
                context?.setStrokeColor(UIColor(shape.color).cgColor)
                context?.setLineWidth(shape.width)
                switch shape.type {
                case .rectangle:
                    context?.addRect(shape.rect)
                case .circle:
                    context?.addEllipse(in: shape.rect)
                }
                context?.strokePath()
            }
        }
        
        return context?.makeImage()
    }
}
