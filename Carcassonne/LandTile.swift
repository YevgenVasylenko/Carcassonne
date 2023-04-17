//
//  LandTile.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import Foundation

enum TileSide {
    case up
    case right
    case down
    case left
    case center
}

enum LandType {
    case field
    case cloister
    case road
    case city
}

protocol TileProtocol {
    var center: LandType { get set }
    var coordinates: (Int, Int) { get set }
}


struct Tile: TileProtocol {
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var center: LandType
    var coordinates: (Int, Int)

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

var tile = Tile(upSide: .road, rightSide: .city, downSide: .field, leftSide: .cloister, center: .cloister, coordinates: (0, 0))

