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

    func possitionInX(coordinatesOfTilesX: Int) {
        frame.origin.x =  view.center.x + CGFloat(coordinatesOfTilesX) * imageSideSize
    }
    
    func possitionInY(coordinateOfTilesY: Int) {
        frame.origin.y =  view.center.y - CGFloat(coordinateOfTilesY) * imageSideSize
    }
    
    func imageRotationPossition(rotationCalculation: Int) {
        for num in 0...rotationCalculation {
            if num != 0 {
                self.transform = self.transform.rotated(by: CGFloat.pi / 2)
            }
        }
    }
    
    func makeShadow(state: TileState) {
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        clipsToBounds = false
        switch state {
        case .moving(let isOkToPlace):
            if isOkToPlace {
                layer.shadowColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
            } else {
                layer.shadowColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            }
        case .placed:
            layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
    }
}
