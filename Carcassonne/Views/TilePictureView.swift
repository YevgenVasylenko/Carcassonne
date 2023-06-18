//
//  TilePictureView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.04.2023.
//

import UIKit

class TilePicture: UIView {
    
    private var view: UIView
    private let tile: Tile
    let tileImageView = UIImageView()
    let meepleImageView = UIImageView()
    var imageSideSize: CGFloat = 0
    
    init(tile: Tile, view: UIView) {
        self.view = view
        self.tile = tile
        super.init(frame: .zero)
        view.addSubview(self)
        drawTilePicture()
        drawOrEraseMeeple()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func makeShadowForObject(object: UIImageView, isObjectPlaced: Bool?, isObjectCanBePlaced: Bool?) {
        
        if isObjectPlaced ?? false {
            return
        }
        
        object.layer.shadowOffset = .zero
        object.layer.shadowRadius = 10
        object.layer.shadowOpacity = 1
        object.clipsToBounds = false
        
        if isObjectCanBePlaced ?? false {
            object.layer.shadowColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        } else {
            object.layer.shadowColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
}

private extension TilePicture {
    
    func drawTilePicture() {
        
        tileImageView.image = UIImage(named: tile.tilePictureName)
        imageSideSize = tileImageView.image?.size.height ?? 0
        tileImageView.frame = CGRect(
            
            origin: objectPositionInView(
                coordinatesOfObjectXY: tile.coordinates,
                sizeOfObject: imageSideSize,
                viewOfCenter: view),
            
            size: .init(width: imageSideSize, height: imageSideSize))
        
        tileImageView.frame.origin.y -= imageSideSize / 2
        tileImageView.frame.origin.x -= imageSideSize / 2
        
        imageRotationPosition(rotationCalculation: tile.rotationCalculation)
        
        self.addSubview(tileImageView)
    }
    
    func drawOrEraseMeeple() {
        
        guard let coordinatesOfMeepleXY = tile.meeple?.coordinates
        else {
            meepleImageView.removeFromSuperview()
            return
        }
        
        var meepleImageSideSize: CGFloat {
            imageSideSize / 3
        }
        
        meepleImageView.image = (UIImage(named: "meeple")?.withTintColor(tile.belongToPlayer?.color ?? .black))
        meepleImageView.frame = CGRect(
            origin: objectPositionInView(
                coordinatesOfObjectXY: coordinatesOfMeepleXY,
                sizeOfObject: meepleImageSideSize,
                viewOfCenter: tileImageView),
            size: .init(width: meepleImageSideSize, height: meepleImageSideSize))
        
        meepleImageView.frame.origin.x -= meepleImageSideSize / 2
        meepleImageView.frame.origin.y -= meepleImageSideSize / 2
        
        self.addSubview(meepleImageView)
    }
    
    func imageRotationPosition(rotationCalculation: Int) {
        tileImageView.transform = CGAffineTransform.identity.rotated(by: (CGFloat.pi / 2) *  CGFloat(rotationCalculation))
    }
    
    func objectPositionInView(coordinatesOfObjectXY: Coordinates, sizeOfObject: CGFloat, viewOfCenter: UIView) -> CGPoint {
        return CGPoint(
            x: viewOfCenter.center.x + CGFloat(coordinatesOfObjectXY.x) * sizeOfObject,
            y: viewOfCenter.center.y - CGFloat(coordinatesOfObjectXY.y) * sizeOfObject)
    }
}
