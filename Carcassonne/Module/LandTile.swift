//
//  LandTile.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import Foundation

enum LandType {
    case field
    case cloister
    case road
    case city
}

enum TileState {
    case placed
    case moving(isOkToPlace: Bool)
    
    var isMoving: Bool {
        switch self {
        case .placed:
            return false
        case .moving:
          return true
        }
    }
}

struct Tile {
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var center: LandType
    var coordinates: (Int, Int) = (0, 0)
    var tilePictureName: String
    var rotationCalculation: Int = 0
    var tileState: TileState = .moving(isOkToPlace: false)

    func isUpNeighbour(_ other: Tile) -> Bool {
        coordinates.1 - other.coordinates.1 == -1
    }
    
    func isRightNeighbour(_ other: Tile) -> Bool {
        coordinates.0 - other.coordinates.0 == -1
    }
    
    func isDownNeighbour(_ other: Tile) -> Bool {
        coordinates.1 - other.coordinates.1 == 1
    }
    
    func isLeftNeighbour(_ other: Tile) -> Bool {
        coordinates.0 - other.coordinates.0 == 1
    }
    
    func isXNeighbour(_ other: Tile) -> Bool {
        coordinates.0 == other.coordinates.0
    }
    
    func isYNeighbour(_ other: Tile) -> Bool {
        coordinates.1 == other.coordinates.1
    }
    
    mutating func rotateClockwise() {
        let temp = upSide
        upSide = leftSide
        leftSide = downSide
        downSide = rightSide
        rightSide = temp
        rotationCalculation += 1
        if rotationCalculation == 4 {
            rotationCalculation = 0
        }
    }
    
    mutating func rotateСounterclockwise() {
        let temp = upSide
        upSide = rightSide
        rightSide = downSide
        downSide = leftSide
        leftSide = temp
        if rotationCalculation == 0 {
            rotationCalculation = 4
        }
        rotationCalculation -= 1
    }
    
    mutating func moveUp() {
        coordinates = (coordinates.0, coordinates.1 + 1)
    }
    
    mutating func moveLeft() {
        coordinates = (coordinates.0 - 1, coordinates.1)
    }
    
    mutating func moveDown() {
        coordinates = (coordinates.0, coordinates.1 - 1)
    }
    
    mutating func moveRight() {
        coordinates = (coordinates.0 + 1, coordinates.1)
    }
}

struct GameCore {
    var tilesStack = [Tile]()
    var tilesOnMap = [Tile]()
    var lastMovingTile: Tile? {
        guard
            let tile = tilesOnMap.last,
            tile.tileState.isMoving
        else {
            return nil
        }
        return tile
    }
        
    var isLastMovingTileCanBePlace: Bool {
        var isLastMovingTileCanBePlace = false
        guard lastMovingTile != nil else { return false }
        isLastMovingTileCanBePlace =  areCoordinatesOkToPlace(currentTile: lastMovingTile!) && areSidesOkToPlace(currentTile: lastMovingTile!)
        return isLastMovingTileCanBePlace
    }
    
    mutating func getMovingTile(action: (inout Tile) -> Void) {
        guard lastMovingTile != nil else { return }
        action(&tilesOnMap[tilesOnMap.count - 1])
    }
        
    mutating func tileFromStack() {
        tilesOnMap.append(tilesStack.removeLast())
    }
    
    mutating func placeTileOnMap() {
        guard isLastMovingTileCanBePlace else {
            print("Not Possible to place")
            return
        }
        getMovingTile { tile in
            tile.tileState = .placed
        }
    }
    
    func areCoordinatesOkToPlace(currentTile: Tile) -> Bool {
        var isCoordinareOkToPlace: Bool = false
        var isXOk = false
        var isYOk = false
        
        for tile in tilesOnMap.dropLast(1) {
            
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
        
        for tile in tilesOnMap.dropLast(1) {
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

        for tile in tilesOnMap.dropLast(1) {
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
