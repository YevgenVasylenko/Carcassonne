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

struct Tile {
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var center: LandType
    var coordinates: (Int, Int) = (0, 0)
    var tilePictureName: String
    var isPosibleToPlace = false

    mutating func rotateClockwise() {
        let temp = upSide
        upSide = leftSide
        leftSide = downSide
        downSide = rightSide
        rightSide = temp
    }
    
    mutating func rotateAnticlockwise() {
        let temp = upSide
        upSide = rightSide
        rightSide = downSide
        downSide = leftSide
        leftSide = temp
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

struct LandScape {
    var tilesStack = [Tile]()
    var tilesOnMap = [Tile]()
    var currentTile: Tile? = nil
    var isCoordinareOkToPlace: Bool = false
    var isSidesOKToPlace: Bool = false
    
    mutating func tileFromStack() {
        currentTile =
        tilesStack.remove(at: Int.random(in: 0...tilesStack.count-1))
    }
    
    mutating func placeTileOnMap() {
        coordinateToPlaceCheck()
        sidesToPlaceCheck()
        if isCoordinareOkToPlace && isSidesOKToPlace == true {
            tilesOnMap.append(currentTile!)
        } else {
            print("Not Possible to place")
        }
    }
    
    func isHaveNeighbourOnUp(tile: Tile) -> Bool {
        currentTile!.coordinates.1 - tile.coordinates.1 == -1
    }
    
    func isHaveNeighbourOnRight(tile: Tile) -> Bool {
        currentTile!.coordinates.0 - tile.coordinates.0 == -1
    }
    
    func isHaveNeighbourOnDown(tile: Tile) -> Bool {
        currentTile!.coordinates.1 - tile.coordinates.1 == 1
    }
    
    func isHaveNeighbourOnLeft(tile: Tile) -> Bool {
        currentTile!.coordinates.0 - tile.coordinates.0 == 1
    }
    
    func isHaveSameXcoordinate(tile: Tile) -> Bool {
        currentTile!.coordinates.0 == tile.coordinates.0
    }
    
    func isHaveSameYcoordinate(tile: Tile) -> Bool {
        currentTile!.coordinates.1 == tile.coordinates.1
    }
    
    mutating func coordinateToPlaceCheck() {
        var isXOk = false
        var isYOk = false
        
        for tile in tilesOnMap {
            
            if isHaveNeighbourOnUp(tile: tile) ||
                isHaveNeighbourOnDown(tile: tile) {
                isYOk = true
            } else {
                isYOk = false
            }
            
            if isHaveNeighbourOnRight(tile: tile) ||
                isHaveNeighbourOnLeft(tile: tile) {
                isXOk = true
            } else {
                isXOk = false
            }

            if isYOk != isXOk {
                break
            }
        }
        
        for tile in tilesOnMap {
            if isHaveSameXcoordinate(tile: tile) &&
                isHaveSameYcoordinate(tile: tile) {
                isXOk = false
                isYOk = false
            }
        }
        
        if isXOk == isYOk {
            isCoordinareOkToPlace = false
        } else {
            if isXOk || isYOk == true {
                isCoordinareOkToPlace = true
            }
        }
    }
    
    mutating func sidesToPlaceCheck() {
        var isUpSideOk = true
        var isRightSideOk = true
        var isDownSideOk = true
        var isLeftSideOk = true

        for tile in tilesOnMap {
            if isHaveNeighbourOnUp(tile: tile) &&
                isHaveSameXcoordinate(tile: tile) {
                if tile.downSide == currentTile?.upSide {
                    isUpSideOk = true
                } else { isUpSideOk = false }
            }
            
            if isHaveNeighbourOnRight(tile: tile) &&
                isHaveSameYcoordinate(tile: tile) {
                if tile.leftSide == currentTile?.rightSide {
                    isRightSideOk = true
                } else { isRightSideOk  = false }
            }
                
            
            if isHaveNeighbourOnDown(tile: tile) &&
                isHaveSameXcoordinate(tile: tile) {
                if tile.upSide == currentTile?.downSide {
                    isDownSideOk = true
                } else { isDownSideOk  = false }
            }
            
            
            if isHaveNeighbourOnLeft(tile: tile) &&
                isHaveSameYcoordinate(tile: tile) {
                if tile.rightSide == currentTile?.leftSide {
                    isLeftSideOk = true
                } else { isLeftSideOk  = false }
            }
        }
        
        if isUpSideOk && isRightSideOk && isDownSideOk && isLeftSideOk {
            isSidesOKToPlace = true
        } else { isSidesOKToPlace = false }
    }
}
