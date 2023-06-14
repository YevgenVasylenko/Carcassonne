//
//  Meeple.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 02.05.2023.
//

import Foundation

enum MeepleType: Hashable {
    case thief
    case knight
    case monk
    case farmer
}

struct Meeple: Hashable {
    static func == (lhs: Meeple, rhs: Meeple) -> Bool {
        return true
    }
    
    var upSide: LandType
    var rightSide: LandType
    var downSide: LandType
    var leftSide: LandType
    var centre: LandType
    var coordinates = Coordinates(x: 0, y: 0)
    var positionLandType: LandType {
        updateLandType()
    }
    
    var positionTileSide: TileSides {
        updateTileSide()
    }
    
    var meepleType: MeepleType {
        positionLandType.meepleTypeChoose()
    }
    var isMeeplePlaced = false
//    var isMeepleOnField: Bool {
//        if positionLandType == .field || positionLandType == .crossroads {
//            return false
//        } else {
//            return true
//        }
//    }
    
    func updateLandType() -> LandType {
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
    
    func updateTileSide() -> TileSides {
        switch coordinates {
        case Coordinates(x: 0, y: 1):
            return .upSide
        case Coordinates(x: 1, y: 0):
            return .rightSide
        case Coordinates(x: 0, y: -1):
            return .downSide
        case Coordinates(x: -1, y: 0):
            return .leftSide
        case Coordinates(x: 0, y: 0):
            return .centre
        default:
            return .centre
        }
    }
    
    func isMeepleCoordinatesOkToPlace(_ coordinates: Coordinates) -> Bool {
        return Coordinates.coordinatesAvailableForMeeple().contains(coordinates)
    }
}
