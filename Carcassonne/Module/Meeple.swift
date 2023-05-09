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
    var possition: LandType? = nil
    var meepleType: MeepleType {
        possition!.meepleTypeChoose()
    }
    var tileSide: TileSides = .center
    var isMeeplePlaced = false
    
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
        if coordinates.1 != 1 {
            coordinates.1 += 1
        }
    }
    
    mutating func moveMeepleRight() {
        if coordinates.0 != 1 {
            coordinates.0 += 1
        }
    }
    
    mutating func moveMeepleDown() {
        if coordinates.1 != -1 {
            coordinates.1 -= 1
        }
    }
    
    mutating func moveMeepleLeft() {
        if coordinates.0 != -1 {
            coordinates.0 -= 1
        }
    }
}
