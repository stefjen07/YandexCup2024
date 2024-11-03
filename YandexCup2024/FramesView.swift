//
//  FramesView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 03.11.2024.
//

import SwiftUI

struct FramesView: View {
    @ObservedObject var session: DrawingSession
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(.adaptive(minimum: 150, maximum: 250), spacing: 25)]) {
                if let canvasSize = session.canvasSize {
                    ForEach(session.layers.enumerated().map { $0 }, id: \.1.id) { (index, layer) in
                        if let image = layer.renderImage(size: canvasSize) {
                            Button(action: {
                                session.selectLayer(index)
                                isPresented = false
                            }, label: {
                                VStack {
                                    Image(image, scale: 1, label: Text("Layer \(index + 1)"))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .background(
                                            Image(.canvasBackground)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        )
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(session.currentLayer === layer ? .selection : .clear)
                                        )
                                    Text("\(index + 1)")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            })
                        }
                    }
                }
            }
            .padding()
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

#Preview {
    FramesView(
        session: .init(selectedColor: .blue, selectedTool: .brush),
        isPresented: .constant(true)
    )
}
