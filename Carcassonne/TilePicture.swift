//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIImageView {
    
    init(tilePictureName: String, view: UIView) {
        super.init(frame: CGRect(x: view.center.x, y: view.center.y, width: 185, height: 185))
        self.image = UIImage(named: tilePictureName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPicture(tilePictureName: String) {
        self.image = UIImage(named: tilePictureName)
    }
    
    func moveUp() {
        self.transform = self.transform.translatedBy(x: 0, y: -185)
    }
    
    func moveRight() {
        self.transform = self.transform.translatedBy(x: +185, y: 0)
    }
    
    func moveDown() {
        self.transform = self.transform.translatedBy(x: 0, y: +185)
    }
    
    func moveLeft() {
        self.transform = self.transform.translatedBy(x: -185, y: 0)
    }
    
    func rotateClockwise() {
        self.transform = self.transform.rotated(by: CGFloat.pi / 2)
    }
    
    func rotateAnticlockwise() {
        self.transform = self.transform.rotated(by: -CGFloat.pi / 2)
    }
    
    func makeRedSignal(shadowColor: UIColor) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 1
        self.clipsToBounds = false
    }
}
