//
//  Tile.swift
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

extension LandType {
    func meepleTypeChoose() -> MeepleType {
        switch self {
        case .field:
            return .farmer
        case .cloister:
            return .monk
        case .road:
            return .thief
        case .city:
            return .knight
        }
    }
}

enum TileSides {
    case upSide
    case rightSide
    case downSide
    case leftSide
    case centre
}

struct Tile {
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var centre: LandType
    var coordinates: (Int, Int) = (0, 0)
    var tilePictureName: String
    var rotationCalculation: Int = 0
    var meeple: Meeple? = nil
    var belongToPlayer: Player? = nil
    var coordinatesAroundTile: [(Int, Int)] {
        fillUpCoordinatesAroundTile()
    }
    
    func isUpNeighbour(_ other: Tile) -> Bool {
        coordinates.1 - other.coordinates.1 == -1
    }
    
    func isDownNeighbour(_ other: Tile) -> Bool {
        coordinates.1 - other.coordinates.1 == 1
    }
    
    func isLeftNeighbour(_ other: Tile) -> Bool {
        coordinates.0 - other.coordinates.0 == 1
    }
    
    func isRightNeighbour(_ other: Tile) -> Bool {
        coordinates.0 - other.coordinates.0 == -1
    }
    
    func isXAxisNeighbour(_ other: Tile) -> Bool {
        (isLeftNeighbour(other) || isRightNeighbour(other)) && isOnSameXAxis(other)
    }
    
    func isYAxisNeighbour(_ other: Tile) -> Bool {
        (isUpNeighbour(other) || isDownNeighbour(other)) && isOnSameYAxis(other)
    }
    
    func isOnSameXAxis(_ other: Tile) -> Bool {
        coordinates.0 == other.coordinates.0
    }
    
    func isOnSameYAxis(_ other: Tile) -> Bool {
        coordinates.1 == other.coordinates.1
    }
    
    func isHasNeighbourAround(_ other: Tile) -> Bool {
        isXAxisNeighbour(other) || isYAxisNeighbour(other)
    }
    
    func isOnSamePlace(_ other: Tile) -> Bool {
        coordinates == other.coordinates
    }
    
    func fillUpCoordinatesAroundTile() -> [(Int, Int)] {
        [
            (coordinates.0-1, coordinates.1+1), (coordinates.0, coordinates.1+1), (coordinates.0+1, coordinates.1+1),
            (coordinates.0-1, coordinates.1), (coordinates.0, coordinates.1), (coordinates.0+1, coordinates.1),
            (coordinates.0-1, coordinates.1-1), (coordinates.0, coordinates.1-1), (coordinates.0+1, coordinates.1-1)
        ]
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
    
    mutating func rotateCounterclockwise() {
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
        coordinates.1 += 1
    }
    
    mutating func moveLeft() {
        coordinates.0 -= 1
    }
    
    mutating func moveDown() {
        coordinates.1 -= 1
    }
    
    mutating func moveRight() {
        coordinates.0 += 1
    }
}

