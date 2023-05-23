//
//  GameViewRendering.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.05.2023.
//

import UIKit

struct Rendering {
    
    let game: GameCore
    let view: UIScrollView
    let superView: UIView

    init(game: GameCore, view: UIScrollView, superView: UIView) {
        self.game = game
        self.view = view
        self.superView = superView
    }
    
    func render() {
        
        var maxCoordinateX = 0
        var minCoordinateX = 0
        var maxCoordinateY = 0
        var minCoordinateY = 0
        
        var absoluteSumX: Int {
            maxCoordinateX + abs(minCoordinateX)
        }
        
        var absoluteSumY: Int {
            maxCoordinateY + abs(minCoordinateY)
        }
        
        for picture in view.subviews {
            picture.removeFromSuperview()
        }
        
        if let tile = game.currentTile {
            maxMinCoordinateSetUp(coordinates: tile.coordinates)
        }
        
        for tile in game.tilesOnMap {
            maxMinCoordinateSetUp(coordinates: tile.coordinates)
        }
        
        for tile in game.tilesOnMap {
            let picture = TilePicture(tile: tile, view: view)
            picture.frame.origin = CGPoint(
                x: picture.imageView.frame.width * CGFloat(abs(minCoordinateX)),
                y: picture.imageView.frame.width * CGFloat(maxCoordinateY))
        }
        
        if let tile = game.currentTile {
            let picture = TilePicture(tile: tile, view: view)
            picture.frame.origin = CGPoint(
                x: picture.imageView.frame.width * CGFloat(abs(minCoordinateX)),
                y: picture.imageView.frame.width * CGFloat(maxCoordinateY))
            picture.makeShadow(isTileCanBePlace: game.isTileCanBePlace)
            view.contentSize = CGSize(
                width: Int(superView.frame.width) + Int(picture.imageView.frame.width) * absoluteSumX,
                height: Int(superView.frame.height) + Int(picture.imageView.frame.width) * absoluteSumY)
        }
        
        func maxMinCoordinateSetUp(coordinates: Coordinates) {
            if coordinates.x > maxCoordinateX {
                maxCoordinateX = coordinates.x
            }
            if coordinates.x < minCoordinateX {
                minCoordinateX = coordinates.x
            }
            if coordinates.y > maxCoordinateY {
                maxCoordinateY = coordinates.y
            }
            if coordinates.y < minCoordinateY {
                minCoordinateY = coordinates.y
            }
        }

    }
}

