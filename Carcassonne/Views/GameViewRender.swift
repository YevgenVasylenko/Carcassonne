//
//  GameViewRender.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.05.2023.
//

import UIKit

struct GameViewRender {
    
    private let game: GameCore
    private let view: UIScrollView
    private let superView: UIView
    private let playersList: UIStackView
    
    private var maxCoordinateX = 0
    private var minCoordinateX = 0
    private var maxCoordinateY = 0
    private var minCoordinateY = 0

    init(game: GameCore, view: UIScrollView, superView: UIView, playersList: UIStackView) {
        self.game = game
        self.view = view
        self.superView = superView
        self.playersList = playersList
    }
    
#warning("why mutating")
    
    mutating func render() {
        
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
            shiftPicturesDueToMapExpansion(picture: picture)
            
            picture.makeShadowForObject(
                object: picture.meepleImageView,
                isObjectPlaced: tile.meeple?.isMeeplePlaced,
                isObjectCanBePlaced: game.isMeepleFreeToBePlaced())
            
            expandMap(picture: picture)
        }
        
        if let tile = game.currentTile {
            let picture = TilePicture(tile: tile, view: view)
            shiftPicturesDueToMapExpansion(picture: picture)
            
            picture.makeShadowForObject(
                object: picture.tileImageView,
                isObjectPlaced: false,
                isObjectCanBePlaced: game.isTileCanBePlace)
        }
        
        for view in playersList.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for player in game.players {
            playersList.addArrangedSubview(
                PlayerLabelGameView(player: player)
            )
        }
    }
}

private extension GameViewRender {
    
    var absoluteSumX: Int {
        maxCoordinateX + abs(minCoordinateX)
    }
    
    var absoluteSumY: Int {
        maxCoordinateY + abs(minCoordinateY)
    }
    
    mutating func maxMinCoordinateSetUp(coordinates: Coordinates) {
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
    
    func shiftPicturesDueToMapExpansion(picture: TilePicture) {
        picture.frame.origin = CGPoint(
            x: picture.imageSideSize * CGFloat(abs(minCoordinateX)),
            y: picture.imageSideSize * CGFloat(maxCoordinateY))
    }
    
    func expandMap(picture: TilePicture) {
        view.contentSize = CGSize(
            width: Int(superView.frame.width) + Int(picture.imageSideSize) * absoluteSumX,
            height: Int(superView.frame.height) + Int(picture.imageSideSize) * absoluteSumY)
    }
}
