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
    
    var coordinates: (Int, Int) = (0, 0)
    
    var position: LandType {
        updateTileSide()
    }
    
    var meepleType: MeepleType {
        position.meepleTypeChoose()
    }
    var isMeeplePlaced = false
    var isMeepleAvailableToStay: Bool {
        isStaymentAvailable()
    }
    var isMeepleOnField: Bool {
        position != .field
    }
    
    func updateTileSide() -> LandType {
        switch coordinates {
        case (0, 1):
            return upSide
        case (1, 0):
            return rightSide
        case (0, -1):
            return downSide
        case (-1, 0):
            return leftSide
        case (0, 0):
            return centre
        case (_, _):
            return centre
        }
    }
    
    mutating func moveMeepleUp() {
        coordinates.1 += 1
        if isMeepleAvailableToStay {
            coordinates.1 -= 1
        }
    }
    
    mutating func moveMeepleRight() {
        coordinates.0 += 1
        if isMeepleAvailableToStay {
            coordinates.0 -= 1
        }
    }
    
    mutating func moveMeepleDown() {
        coordinates.1 -= 1
        if isMeepleAvailableToStay {
            coordinates.1 += 1
        }
    }
    
    mutating func moveMeepleLeft() {
        var oldCoordinates = coordinates
        coordinates.0 -= 1
        if isMeepleAvailableToStay {
            coordinates = oldCoordinates
        }
    }
    
    func isStaymentAvailable() -> Bool {
        return abs(coordinates.0) + abs(coordinates.1) == 2
    }
}
