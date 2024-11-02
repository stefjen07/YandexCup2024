//
//  ContentView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import SwiftUI
import SwiftData

enum ToolType: Int, Identifiable, CaseIterable {
    case pencil
    case brush
    case eraser
    
    var id: Int {
        rawValue
    }
    
    var icon: Image {
        switch self {
        case .pencil:
            .init(.pencil)
        case .brush:
            .init(.brush)
        case .eraser:
            .init(.erase)
        }
    }
}

enum PickerType {
    case color
    case shape
}

struct ContentView: View {
    @ObservedObject var session: DrawingSession = .init(selectedColor: .blue, selectedTool: .pencil)
    
    var body: some View {
        SessionView(session: session, currentLayer: session.currentLayer)
    }
}

#Preview {
    ContentView()
}
