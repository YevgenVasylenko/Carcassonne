//
//  Tile.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import Foundation

protocol Matchable {
  static func == (lhs: Self, rhs: Self) -> Bool
}

protocol NotMatchable {
    static func != (lhs: Self, rhs: Self) -> Bool
}

enum LandType: Hashable {
    case field
    case cloister
    case road(endOfRoad: Bool)
    case city(separated: Bool)
    case crossroads
}

extension LandType: Matchable {
    static func == (lhs: LandType, rhs: LandType) -> Bool {
        switch (lhs, rhs) {
        case (.field, .field): return true
        case (.cloister, .cloister): return true
        case (.road(_), .road(_)): return true
        case (.city(_), .city(_)): return true
        case (.crossroads, .crossroads): return true
        default: return false
        }
    }
}

extension LandType: NotMatchable {
    static func != (lhs: LandType, rhs: LandType) -> Bool {
        switch (lhs, rhs) {
        case (.field, .field): return false
        case (.cloister, .cloister): return false
        case (.road(endOfRoad: true), .road(endOfRoad: true)): return false
        case (.road(endOfRoad: false), .road(endOfRoad: false)): return false
        case (.city(separated: true), .city(separated: true)): return false
        case (.city(separated: false), .city(separated: false)): return false
        case (.crossroads, .crossroads): return false
        default: return true
        }
    }
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
        case .crossroads:
            return .thief
        }
    }
    
    func isAnotherMeeplePlacable(landTypeToCheck: LandType) -> Bool {
        switch self {
        case .field:
            break
        case .cloister:
            return self == .cloister
        case .road:
            return landTypeToCheck == .cloister || landTypeToCheck == .city(separated: false)
        case .city:
            return landTypeToCheck == .cloister || landTypeToCheck == .road(endOfRoad: false)
        case .crossroads:
            break
        }
        return false
    }
}

enum TileSides: Hashable {
    case upSide
    case rightSide
    case downSide
    case leftSide
    case centre
}

extension TileSides {
    func getOppositeSide() -> Self {
        switch self {
        case .upSide:
            return .downSide
        case .rightSide:
            return .leftSide
        case .downSide:
            return .upSide
        case .leftSide:
            return .rightSide
        case .centre:
            return .centre
        }
    }
}

struct Tile: Hashable {
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
            return lhs.coordinates == rhs.coordinates
        }
    
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
    let isTileArmed: Bool

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
    
    func getLandTypeForSide(_ side: TileSides) -> LandType {
        switch side {
        case .upSide:
            return upSide
        case .rightSide:
            return rightSide
        case .downSide:
            return downSide
        case .leftSide:
            return leftSide
        case .centre:
            return centre
        }
    }
}

