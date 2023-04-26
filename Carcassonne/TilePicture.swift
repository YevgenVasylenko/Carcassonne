//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIImageView {
    var view: UIView
    
    init(tilePictureName: String, view: UIView) {
        self.view = view
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
    
//    func moveUp() {
//        frame.origin.y -= imageSideSize
//    }
//
//    func moveRight() {
//        frame.origin.x += imageSideSize
//    }
//
//    func moveDown() {
//        frame.origin.y += imageSideSize
//    }
//
//    func moveLeft() {
//        frame.origin.x -= imageSideSize
//    }
//
    func possitionInX(coordinatesOfTilesX: Int) {
        frame.origin.x =  view.center.x + CGFloat(coordinatesOfTilesX) * imageSideSize
    }
    
    func possitionInY(coordinateOfTilesY: Int) {
        frame.origin.y =  view.center.y - CGFloat(coordinateOfTilesY) * imageSideSize
    }
    
//    func rotateClockwise() {
//        self.transform = self.transform.rotated(by: CGFloat.pi / 2)
//    }
//
//    func rotateAnticlockwise() {
//        self.transform = self.transform.rotated(by: -CGFloat.pi / 2)
//    }
    
    func imageRotationPossition(rotationCalculation: Int) {
        for num in 0...rotationCalculation {
            if num != 0 {
                self.transform = self.transform.rotated(by: CGFloat.pi / 2)
            }
        }
        
//        if rotationCalculation != 0 {
//            self.transform = self.transform.rotated(by: CGFloat(Float.pi / Float(2 * rotationCalculation)))
//        }
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
