//
//  YandexCup2024App.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import SwiftUI

@main
struct YandexCup2024App: App {
    @ObservedObject var session: DrawingSession = .init(selectedColor: .blue, selectedTool: .pencil)
    
    var body: some Scene {
        WindowGroup {
            SessionView(session: session, currentLayer: session.currentLayer)
        }
    }
}
