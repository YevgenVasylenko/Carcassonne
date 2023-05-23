//
//  TilePictureView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIView {
    
    var view: UIView
    let imageView = UIImageView()
    
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
            origin: positionInXY(coordinatesOfTilesXY: tile.coordinates, imageSideSize: imageSideSize),
            size: .init(width: imageSideSize, height: imageSideSize))
        
        imageRotationPosition(rotationCalculation: tile.rotationCalculation)
        self.addSubview(imageView)
        
        DrawOrEraseMeeple(coordinatesOfMeepleXY: tile.meeple?.coordinates,   imageSideSize: imageSideSize, isMeepleCanBePlace: tile.meeple?.isMeepleOnField ?? false, isMeeplePlaced: tile.meeple?.isMeeplePlaced ?? false, meepleColor: tile.belongToPlayer?.color ?? .black)
        
    }
    
    func positionInXY(coordinatesOfTilesXY: Coordinates, imageSideSize: CGFloat) -> CGPoint {
        return CGPoint(
            x: (view.center.x - imageSideSize / 2) + CGFloat(coordinatesOfTilesXY.x) * imageSideSize,
            y: (view.center.y - imageSideSize / 2) - CGFloat(coordinatesOfTilesXY.y) * imageSideSize)
    }
    
    func imageRotationPosition(rotationCalculation: Int) {
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
    
    func DrawOrEraseMeeple(coordinatesOfMeepleXY: (Int, Int)?, imageSideSize: CGFloat, isMeepleCanBePlace: Bool, isMeeplePlaced: Bool, meepleColor: UIColor) {
        
        let meeplePicture = UIImageView()
        
        var meepleImageSideSize: CGFloat {
            imageSideSize / 3
        }
        
        guard  let coordinatesOfMeepleXY = coordinatesOfMeepleXY else {
            meeplePicture.removeFromSuperview()
            return
        }
        
        meeplePicture.image = (UIImage(named: "meeple")?.withTintColor(meepleColor))
        meeplePicture.frame = CGRect(
            origin: meeplePositionInXY(coordinatesOfMeepleXY: coordinatesOfMeepleXY, meepleImageSideSize: meepleImageSideSize),
            size: .init(width: meepleImageSideSize, height: meepleImageSideSize))
        makeShadow(isMeeplePlaced: isMeeplePlaced, isMeepleCanBePlace: isMeepleCanBePlace)
        
        self.addSubview(meeplePicture)
        
        func makeShadow(isMeeplePlaced: Bool, isMeepleCanBePlace: Bool) {
            if isMeeplePlaced {
                return
            }
            
            meeplePicture.layer.shadowOffset = .zero
            meeplePicture.layer.shadowRadius = 10
            meeplePicture.layer.shadowOpacity = 1
            meeplePicture.clipsToBounds = false
            
            if isMeepleCanBePlace {
                meeplePicture.layer.shadowColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
            } else {
                meeplePicture.layer.shadowColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func meeplePositionInXY(coordinatesOfMeepleXY: (Int, Int), meepleImageSideSize: CGFloat) -> CGPoint {
        return CGPoint(
            x: (imageView.center.x - meepleImageSideSize / 2) + CGFloat(coordinatesOfMeepleXY.0) * meepleImageSideSize,
            y: (imageView.center.y - meepleImageSideSize / 2) - CGFloat(coordinatesOfMeepleXY.1) * meepleImageSideSize)
    }
}
