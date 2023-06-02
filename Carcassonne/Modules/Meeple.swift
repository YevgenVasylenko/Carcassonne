//
//  Meeple.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 02.05.2023.
//

import Foundation

enum MeepleType {
    case thief
    case knight
    case monk
    case farmer
}

struct Meeple {
    
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var centre: LandType
    var coordinates = Coordinates(x: 0, y: 0)
    var position: LandType {
        updateTileSide()
    }
    
    var meepleType: MeepleType {
        position.meepleTypeChoose()
    }
    var isMeeplePlaced = false
    var isMeepleOnField: Bool {
        position != .field
    }
    
    func updateTileSide() -> LandType {
        switch coordinates {
        case Coordinates(x: 0, y: 1):
            return upSide
        case Coordinates(x: 1, y: 0):
            return rightSide
        case Coordinates(x: 0, y: -1):
            return downSide
        case Coordinates(x: -1, y: 0):
            return leftSide
        case Coordinates(x: 0, y: 0):
            return centre
        default:
            return centre
        }
    }
    
    func isMeepleCoordinatesOkToPlace(_ coordinates: Coordinates) -> Bool {
        return Coordinates.coordinatesAvailableForMeeple().contains(coordinates)
    }
}
