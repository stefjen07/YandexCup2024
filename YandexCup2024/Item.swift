//
//  Item.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 28.10.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
