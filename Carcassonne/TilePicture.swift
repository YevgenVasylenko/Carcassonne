//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIView {
    
    var view: UIView
    private let imageView = UIImageView()
    
    init(tile: Tile, view: UIView) {
        self.view = view
        super.init(frame: .zero)
        
        view.addSubview(self)
        drawTilePicture(tile: tile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawTilePicture(tile: Tile) {
        var imageSideSize: CGFloat {
            imageView.image?.size.height ?? 0
            }
        
        imageView.image = UIImage(named: tile.tilePictureName)
        imageView.frame = CGRect(
            origin: possitionInXY(coordinatesOfTilesXY: tile.coordinates, imageSideSize: imageSideSize),
            size: .init(width: imageSideSize, height: imageSideSize))

        imageRotationPossition(rotationCalculation: tile.rotationCalculation)
        self.addSubview(imageView)
        
        DrawOrEraseMeeple(coordinatesOfMeepleXY: tile.meeple.coordinates, isTileHaveMeeple: tile.meeple.isMeeplePlaced, imageSideSize: imageSideSize)
        
    }

    func possitionInXY(coordinatesOfTilesXY: (Int, Int), imageSideSize: CGFloat) -> CGPoint {
        return CGPoint(
            x: view.center.x + CGFloat(coordinatesOfTilesXY.0) * imageSideSize,
            y: view.center.y - CGFloat(coordinatesOfTilesXY.1) * imageSideSize)
    }
    
    func imageRotationPossition(rotationCalculation: Int) {
        imageView.transform = CGAffineTransform.identity.rotated(by: (CGFloat.pi / 2) *  CGFloat(rotationCalculation))

    }
    
    func makeShadow(isTileCanBePlace: Bool) {
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        clipsToBounds = false
        if isTileCanBePlace {
            layer.shadowColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        } else {
            layer.shadowColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
    

    func DrawOrEraseMeeple(coordinatesOfMeepleXY: (Int, Int), isTileHaveMeeple: Bool, imageSideSize: CGFloat) {
        
        let meeplePicture = UIImageView()
        
        var meepleImageSideSize: CGFloat {
            imageSideSize / 3
        }
        
        if isTileHaveMeeple {
            meeplePicture.image = UIImage(named: "meeple")
            meeplePicture.frame = CGRect(
                origin: meeplePossitionInXY(coordinatesOfMeepleXY: coordinatesOfMeepleXY, meepleImageSideSize: meepleImageSideSize),
                size: .init(width: meepleImageSideSize, height: meepleImageSideSize))
            self.addSubview(meeplePicture)
        } else {
            meeplePicture.removeFromSuperview()
        }
    }
    
    func meeplePossitionInXY(coordinatesOfMeepleXY: (Int, Int), meepleImageSideSize: CGFloat) -> CGPoint {
        return CGPoint(
            x: (imageView.center.x - meepleImageSideSize / 2) + CGFloat(coordinatesOfMeepleXY.0) * meepleImageSideSize,
            y: (imageView.center.y - meepleImageSideSize / 2) - CGFloat(coordinatesOfMeepleXY.1) * meepleImageSideSize)
    }
}

