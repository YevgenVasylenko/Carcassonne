//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIImageView {
    
    init(tilePictureName: String, view: UIView) {
        super.init(frame: .zero)
        
        image = UIImage(named: tilePictureName)
        frame = CGRect(
            origin: view.center,
            size: .init(width: imageSideSize, height: imageSideSize)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageSideSize: CGFloat {
        image?.size.height ?? 0
    }
    
    func moveUp() {
        frame.origin.y -= imageSideSize
    }
    
    func moveRight() {
        frame.origin.x += imageSideSize
    }
    
    func moveDown() {
        frame.origin.y += imageSideSize
    }
    
    func moveLeft() {
        frame.origin.x -= imageSideSize
    }
    
    func rotateClockwise() {
        self.transform = self.transform.rotated(by: CGFloat.pi / 2)
    }
    
    func rotateAnticlockwise() {
        self.transform = self.transform.rotated(by: -CGFloat.pi / 2)
    }
    
    func makeRedSignal(shadowColor: UIColor) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        clipsToBounds = false
        alpha = 0.5
    }
    
    func placed() {
        alpha = 1
    }
}
