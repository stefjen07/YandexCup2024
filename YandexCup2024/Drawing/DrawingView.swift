//
//  DrawingView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 02.11.2024.
//

import SwiftUI
import Combine

class DrawingView: UIView {
    var session: DrawingSession
    var sessionCancellable: AnyCancellable?
    
    private let gestureRecognizer = DrawingGestureRecognizer()
    
    init(session: DrawingSession) {
        self.session = session
        
        super.init(frame: .zero)
        
        session.drawingView = self
        
        isOpaque = false
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        session.currentLayer.strokes.forEach(drawStroke)
        if let stroke = gestureRecognizer.stroke {
            drawStroke(stroke)
        }
    }
    
    private func drawStroke(_ stroke: Stroke) {
        guard let firstPoint = stroke.points.first else {
            return
        }
        
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

struct DrawingViewRepresentable: UIViewRepresentable {
    @ObservedObject var session: DrawingSession
    
    func makeUIView(context: Context) -> DrawingView {
        .init(session: session)
    }
    
    func updateUIView(_ view: DrawingView, context: Context) {
        
    }
}
