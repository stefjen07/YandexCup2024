//
//  CGPoint+Extensions.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 04.11.2024.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(point.x - x, 2) + pow(point.y - y, 2))
    }
}
