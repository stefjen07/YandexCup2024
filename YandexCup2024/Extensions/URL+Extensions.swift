//
//  URL+Extensions.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 03.11.2024.
//

import Foundation

extension URL: Identifiable {
    public var id: Int {
        hashValue
    }
}
