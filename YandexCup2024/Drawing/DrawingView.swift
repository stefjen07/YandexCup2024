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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        session.canvasSize = frame.size
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        session.currentLayer.strokes.forEach(drawStroke)
        if let stroke = gestureRecognizer.stroke {
            drawStroke(stroke)
        }
    }
    
    private func drawStroke(_ stroke: Stroke) {
        UIColor(stroke.color).setStroke()
        stroke.path?.stroke()
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
