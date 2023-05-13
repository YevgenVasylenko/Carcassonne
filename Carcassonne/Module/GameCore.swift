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
    var currentTile: Tile? = nil
    var unsafeLastTile: Tile {
        get {
            return tilesOnMap[tilesOnMap.count - 1]
        }
        set {
            tilesOnMap[tilesOnMap.count - 1] = newValue
        }
    }
    
    var isTileCanBePlace: Bool {
        guard let currentTile = currentTile else { return false }
        return areCoordinatesOkToPlace(currentTile: currentTile) &&
        areSidesOkToPlace(currentTile: currentTile)
    }
    
    var gameState: GameState {
        gameStateChange()
    }
    
    init(tilesStack: [Tile], firstTile: Tile) {
        self.tilesStack = tilesStack
        
        tilesOnMap.reserveCapacity(tilesStack.count)
        tilesOnMap.append(firstTile)
    }
    
    func gameStateChange() -> GameState {
        if currentTile != nil {
            return .currentTileOperate(isCanBePlace: isTileCanBePlace)
        } else {
            if tilesOnMap.last?.meeple != nil {
                return .currentTileNotOperate(meepleOperate: .meepleOperate(true,  unsafeLastTile.meeple?.isMeeplePlaced ?? false))
            } else {
                return .currentTileNotOperate(meepleOperate: .meepleNotOperate)
            }
        }
    }
    
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
    
    mutating func createMeeple() {
        unsafeLastTile.meeple = Meeple()
    }
    
    mutating func placeMeeple() {
        unsafeLastTile.meeple?.isMeeplePlaced = true
    }
    
    mutating func pickUpMeeple() {
        unsafeLastTile.meeple?.isMeeplePlaced = false
    }
    
    mutating func removeMeeple() {
        unsafeLastTile.meeple = nil
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
