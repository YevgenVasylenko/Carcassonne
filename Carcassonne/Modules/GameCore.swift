//
//  GameCore.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 07.05.2023.
//

import Foundation

enum GameState {
    case gameStart
    case currentTileOperate(isCanBePlace: Bool)
    case currentTileNotOperate(meepleOperate: MeepleOperate)
    
    enum MeepleOperate {
        case meepleOperate(Bool, Bool)
        case meepleNotOperate
    }
}

struct GameCore {
    var tilesStack = [Tile]()
    var tilesOnMap = [Tile]()
    var currentTile: Tile? = nil {
        didSet {
            guard let currentTile = currentTile else { return }
            isTileCanBePlace = areCoordinatesOkToPlace(currentTileCoordinates: currentTile.coordinates) &&
            areSidesOkToPlace(currentTile: currentTile)
        }
    }
    var players = [Player]()
    private var playerIndex = 0
    
    
    var currentPlayer: Player? {
        players[playerIndex]
    }
    
    var unsafeLastTile: Tile {
        get {
            return tilesOnMap[tilesOnMap.count - 1]
        }
        set {
            tilesOnMap[tilesOnMap.count - 1] = newValue
        }
    }
    
    var isTileCanBePlace: Bool = false
        
    
    var gameState: GameState {
        gameStateChange()
    }
    
    init(tilesStack: [Tile], firstTile: Tile) {
        self.tilesStack = tilesStack
        
        tilesOnMap.reserveCapacity(tilesStack.count)
        tilesOnMap.append(firstTile)
    }
    
    mutating func tileFromStack() {
        currentTile = tilesStack.removeLast()
        changePlayerIndex()
    }
    
    mutating func placeTileOnMap() {
        guard var currentTile = currentTile else {
            return
        }
        currentTile.belongToPlayer = currentPlayer
        tilesOnMap.append(currentTile)
        self.currentTile = nil
    }
    
    mutating func takeTileBack() {
        currentTile = tilesOnMap.removeLast()
    }
    
    mutating func createMeeple() {
        unsafeLastTile.meeple = Meeple(upSide: unsafeLastTile.upSide, rightSide: unsafeLastTile.rightSide, downSide: unsafeLastTile.downSide, leftSide: unsafeLastTile.leftSide, centre: unsafeLastTile.centre)
    }
    
    mutating func placeMeeple() {
        if unsafeLastTile.meeple?.isMeepleOnField ?? false {
            unsafeLastTile.meeple?.isMeeplePlaced = true
        }
    }
    
    mutating func pickUpMeeple() {
        unsafeLastTile.meeple?.isMeeplePlaced = false
    }
    
    mutating func removeMeeple() {
        unsafeLastTile.meeple = nil
    }
    
    func isMovementAvailable(_ mapCoordinates: (Coordinates) -> Coordinates) -> Bool {
        guard var coordinates = currentTile?.coordinates else {
            return true
        }
        coordinates = mapCoordinates(coordinates)
        return tilesOnMap
            .contains(where: { tile in
                coordinates
                    .coordinatesAroundTile()
                    .contains(tile.coordinates)
            })
    }
}

private extension GameCore {
    
    func gameStateChange() -> GameState {
        if currentTile != nil {
            return .currentTileOperate(isCanBePlace: isTileCanBePlace)
        } else {
            if tilesOnMap.last?.meeple != nil {
                return .currentTileNotOperate(meepleOperate: .meepleOperate(unsafeLastTile.meeple?.isMeepleOnField ?? false,  unsafeLastTile.meeple?.isMeeplePlaced ?? false))
            } else {
                return .currentTileNotOperate(meepleOperate: .meepleNotOperate)
            }
        }
    }
    
    mutating func changePlayerIndex() {
        if playerIndex == players.count - 1 {
            playerIndex = 0
        } else if playerIndex < players.count - 1 {
            playerIndex += 1
        }
    }
    
    func areCoordinatesOkToPlace(currentTileCoordinates: Coordinates) -> Bool {
        var isCoordinateOkToPlace: Bool = false
        var isXOk = false
        var isYOk = false
        
        for tile in tilesOnMap {

            isYOk = currentTileCoordinates.isYAxisNeighbour(tile.coordinates)

            isXOk = currentTileCoordinates.isXAxisNeighbour(tile.coordinates)
            
            if isYOk != isXOk {
                break
            }
        }
        
        for tile in tilesOnMap {
            if currentTileCoordinates.isOnSameXAxis(tile.coordinates) &&
                currentTileCoordinates.isOnSameYAxis(tile.coordinates) {
                isXOk = false
                isYOk = false
            }
        }
        
        if isXOk == isYOk {
            isCoordinateOkToPlace = false
            print("coordinates no Ok")
        } else {
            isCoordinateOkToPlace = true
            print("coordinates Ok")
        }
        return isCoordinateOkToPlace
    }
    
    func areSidesOkToPlace(currentTile: Tile) -> Bool {
        var isUpSideOk = true
        var isRightSideOk = true
        var isDownSideOk = true
        var isLeftSideOk = true
        
        for tile in tilesOnMap {
            if currentTile.coordinates.isUpNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameXAxis(tile.coordinates) {
                isUpSideOk = tile.downSide == currentTile.upSide
            }
            
            if currentTile.coordinates.isRightNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameYAxis(tile.coordinates) {
                isRightSideOk = tile.leftSide == currentTile.rightSide
            }
            
            if currentTile.coordinates.isDownNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameXAxis(tile.coordinates) {
                isDownSideOk = tile.upSide == currentTile.downSide
            }
            
            if currentTile.coordinates.isLeftNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameYAxis(tile.coordinates) {
                isLeftSideOk = tile.rightSide == currentTile.leftSide
            }
        }
        return isUpSideOk && isRightSideOk && isDownSideOk && isLeftSideOk
    }


}
