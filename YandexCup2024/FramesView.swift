//
//  FramesView.swift
//  YandexCup2024
//
//  Created by Yauheni Stsefankou on 03.11.2024.
//

import SwiftUI

class FrameView: UICollectionViewCell {
    static let identifier = "frameView"
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        imageView.layer.cornerRadius = 10
        
        addSubview(imageView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(image: UIImage, text: String, isSelected: Bool) {
        imageView.image = image
        if isSelected {
            imageView.layer.borderColor = UIColor(resource: .selection).cgColor
            imageView.layer.borderWidth = 1
        } else {
            imageView.layer.borderColor = nil
            imageView.layer.borderWidth = 0
        }
        label.text = text
    }
}

class FramesCollectionViewController: UICollectionViewController {
    private let session: DrawingSession
    var dismiss: (() -> Void)?
    
    init(session: DrawingSession) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        self.session = session
        super.init(collectionViewLayout: layout)
        
        layout.itemSize = previewSize
        
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.layer.cornerRadius = 20
        collectionView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        collectionView.register(FrameView.self, forCellWithReuseIdentifier: FrameView.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previewSize: CGSize {
        guard let canvasSize = session.canvasSize else { return .zero }
        let scale = 150 / canvasSize.height
        
        return canvasSize.applying(.init(scaleX: scale, y: scale)).applying(.init(translationX: 0, y: 20))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        session.layers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameView.identifier, for: indexPath) as? FrameView else {
            return .init()
        }
        
        let index = indexPath.row
        let layer = session.layers[index]
        if let canvasSize = self.session.canvasSize,
           let cgImage = layer.renderImage(size: canvasSize, scale: 150 / canvasSize.height)
        {
            cell.update(image: UIImage(cgImage: cgImage), text: "\(index + 1)", isSelected: layer === session.currentLayer)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        session.selectLayer(indexPath.row)
        dismiss?()
    }
}

struct FramesCollectionView: UIViewControllerRepresentable {
    let session: DrawingSession
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> FramesCollectionViewController {
        let controller = FramesCollectionViewController(session: session)
        controller.dismiss = {
            self.isPresented = false
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: FramesCollectionViewController, context: Context) {
        uiViewController.collectionView.reloadData()
    }
}
