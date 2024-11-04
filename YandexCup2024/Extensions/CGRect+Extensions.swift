//
//  CGRect+Extensions.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 04.11.2024.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        .init(x: midX, y: midY)
    }
    
    var radius: CGFloat {
        min(width, height) * 0.5
    }
}
