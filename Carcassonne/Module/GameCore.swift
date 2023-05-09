//
//  GameCore.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 07.05.2023.
//

import Foundation

enum GameState {
    case gameStart
    case currentTileOperrate(isCanBePlace: Bool)
    case currentTileNotOperrrate
    case meepleOperrate(isCanBePlace: Bool)
    case meepleNotOperrate
}

struct GameCore {
    var tilesStack = [Tile]()
    var tilesOnMap = [Tile]()
    var currentTile: Tile? = nil
    
    var isTileCanBePlace: Bool {
        var isLastMovingTileCanBePlace = false
        guard let currentTile = currentTile else { return false }
        isLastMovingTileCanBePlace = areCoordinatesOkToPlace(currentTile: currentTile) &&
        areSidesOkToPlace(currentTile: currentTile)
        return isLastMovingTileCanBePlace
    }
    
//    var gameState: GameState {
//        
//    }
//    
//    func gameState
    
    mutating func tileFromStack() {
        currentTile = tilesStack.removeLast()
    }
    
    mutating func placeTileOnMap() {
        guard let currentTile = currentTile else {
            print("Not Possible to place")
            return
        }
        tilesOnMap.append(currentTile)
        self.currentTile = nil
    }
    
    mutating func takeTileBack() {
        currentTile = tilesOnMap.removeLast()
    }
    
    mutating func placeMeeple() {
        tilesOnMap[tilesOnMap.count-1].placeMeeple()
    }
    
    func areCoordinatesOkToPlace(currentTile: Tile) -> Bool {
        var isCoordinareOkToPlace: Bool = false
        var isXOk = false
        var isYOk = false
        
        for tile in tilesOnMap {
            
            if (currentTile.isUpNeighbour(tile) ||
                currentTile.isDownNeighbour(tile)) &&
                currentTile.isXNeighbour(tile) {
                isYOk = true
            } else {
                isYOk = false
            }
            
            if (currentTile.isRightNeighbour(tile) ||
                currentTile.isLeftNeighbour(tile)) &&
                currentTile.isYNeighbour(tile) {
                isXOk = true
            } else {
                isXOk = false
            }

            if isYOk != isXOk {
                break
            }
        }
        
        for tile in tilesOnMap {
            if currentTile.isXNeighbour(tile) &&
                currentTile.isYNeighbour(tile) {
                isXOk = false
                isYOk = false
            }
        }
        
        if isXOk == isYOk {
            isCoordinareOkToPlace = false
            print("Coordinates is Not OK")
        } else {
                isCoordinareOkToPlace = true
                print("Coordinates is OK")
        }
        return isCoordinareOkToPlace
    }
    
    func areSidesOkToPlace(currentTile: Tile) -> Bool {
        var isSidesOKToPlace: Bool = false
        var isUpSideOk = true
        var isRightSideOk = true
        var isDownSideOk = true
        var isLeftSideOk = true

        for tile in tilesOnMap {
            if currentTile.isUpNeighbour(tile) &&
                currentTile.isXNeighbour(tile) {
                if tile.downSide == currentTile.upSide {
                    isUpSideOk = true
                } else { isUpSideOk = false }
            }
            
            if currentTile.isRightNeighbour(tile) &&
                currentTile.isYNeighbour(tile) {
                if tile.leftSide == currentTile.rightSide {
                    isRightSideOk = true
                } else { isRightSideOk  = false }
            }
                
            
            if currentTile.isDownNeighbour(tile) &&
                currentTile.isXNeighbour(tile) {
                if tile.upSide == currentTile.downSide {
                    isDownSideOk = true
                } else { isDownSideOk  = false }
            }
            
            
            if currentTile.isLeftNeighbour(tile) &&
                currentTile.isYNeighbour(tile) {
                if tile.rightSide == currentTile.leftSide {
                    isLeftSideOk = true
                } else { isLeftSideOk  = false }
            }
        }
        
        if isUpSideOk && isRightSideOk && isDownSideOk && isLeftSideOk {
            isSidesOKToPlace = true
            print("Sides is OK")
        } else {
        isSidesOKToPlace = false
            print("Sides is not OK")
        }
        return isSidesOKToPlace
    }
}
