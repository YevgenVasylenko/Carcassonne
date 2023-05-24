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
    var coordinates = Coordinates(x: 0, y: 0)
    var tilePictureName: String
    var rotationCalculation: Int = 0
    var meeple: Meeple? = nil
    var belongToPlayer: Player? = nil

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
}

