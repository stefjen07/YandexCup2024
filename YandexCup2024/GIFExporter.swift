//
//  GIFExporter.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 03.11.2024.
//

import Foundation
import ImageIO
import UniformTypeIdentifiers
import UIKit

class GIFExporter {
    private var newFileURL: URL {
        let filename = UUID().uuidString + ".gif"
        return URL(filePath: NSTemporaryDirectory()).appendingPathComponent(filename)
    }
    
    private func createEmptyFile(url: URL, framesCount: Int) -> CGImageDestination? {
        guard let file = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.gif.identifier as CFString,
            framesCount,
            nil
        ) else {
            return nil
        }
        
        CGImageDestinationSetProperties(file, [
            kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]
        ] as CFDictionary)
        
        return file
    }
    
    func export(layers: [DrawingLayer], fps: Int, size: CGSize) -> URL? {
        let url = newFileURL
        
        guard let file = createEmptyFile(url: url, framesCount: layers.count) else {
            return nil
        }
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 1.0 / Double(fps)]
        ]
        
        let scale = UIScreen.main.scale
        for layer in layers {
            if let image = layer.renderImage(size: size, scale: scale) {
                CGImageDestinationAddImage(file, image, frameProperties as CFDictionary)
            }
        }
        
        CGImageDestinationFinalize(file)
        
        return url
    }
}
