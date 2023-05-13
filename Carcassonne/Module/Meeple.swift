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
    
    var coordinates: (Int, Int) = (0, 0) {
        didSet {
            updateTileSide()
        }
    }
    var position: LandType? = nil
    var meepleType: MeepleType {
        position!.meepleTypeChoose()
    }
    var tileSide: TileSides = .center
    var isMeeplePlaced = false
    var isMeepleAvailableToStay: Bool {
        isStaymentAvailable()
    }
    
    mutating func updateTileSide() {
        switch coordinates {
        case (0, 1):
            tileSide = .upSide
        case (1, 0):
            tileSide = .rightSide
        case (0, -1):
            tileSide = .downSide
        case (-1, 0):
            tileSide = .leftSide
        case (0, 0):
            tileSide = .center
        case (_, _):
            return
        }
    }
    
    mutating func moveMeepleUp() {
        coordinates.1 += 1
        if !isMeepleAvailableToStay {
            coordinates.1 -= 1
        }
    }
    
    mutating func moveMeepleRight() {
        coordinates.0 += 1
        if !isMeepleAvailableToStay {
            coordinates.0 -= 1
        }
    }
    
    mutating func moveMeepleDown() {
        coordinates.1 -= 1
        if !isMeepleAvailableToStay {
            coordinates.1 += 1
        }
    }
    
    mutating func moveMeepleLeft() {
        coordinates.0 -= 1
        if !isMeepleAvailableToStay {
            coordinates.0 += 1
        }
    }
    
    func isStaymentAvailable() -> Bool {
        return coordinates != (0, 2) && coordinates != ( 2, 0) && coordinates != (0, -2) && coordinates != (-2, 0) && coordinates != (1, 1) && coordinates != (-1, -1) && coordinates != (-1, 1) && coordinates != (1, -1)
    }
}
