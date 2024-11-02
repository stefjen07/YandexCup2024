//
//  DrawingLayer.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import Foundation

class DrawingLayer: ObservableObject {
    @Published private(set) var strokes: [Stroke] = []
    private var undoStrokes: [Stroke] = []
    
    func copyContent(to layer: DrawingLayer) {
        layer.strokes = strokes
    }
    
    func addStroke(_ stroke: Stroke) {
        strokes.append(stroke)
        undoStrokes = []
    }
    
    func undo() {
        guard !strokes.isEmpty else { return }
        undoStrokes.append(strokes.removeLast())
    }
    
    func redo() {
        guard !undoStrokes.isEmpty else { return }
        strokes.append(undoStrokes.removeFirst())
    }
    
    var isUndoDisabled: Bool {
        strokes.isEmpty
    }
    
    var isRedoDisabled: Bool {
        undoStrokes.isEmpty
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
    
    func eraseStrokes(byLine line: (CGPoint, CGPoint)) {
        var newStrokes: [Stroke] = []
        strokes.forEach {
            for i in 1..<$0.points.count {
                if linesCross(start1: line.0, end1: line.1, start2: $0.points[i-1], end2: $0.points[i]) {
                    undoStrokes.append($0)
                    return
                }
            }
            newStrokes.append($0)
        }
        strokes = newStrokes
    }
}
