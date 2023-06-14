//
//  Coordinates.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 23.05.2023.
//

import Foundation

struct Coordinates: Equatable, Hashable {
    var x: Int
    var y: Int
    
    static var zero: Self {
        Self(x: 0, y: 0)
    }
    
    mutating func moveUp() {
        y += 1
    }
    
    mutating func moveLeft() {
        x -= 1
    }
    
    mutating func moveDown() {
        y -= 1
    }
    
    mutating func moveRight() {
        x += 1
    }
    
    func up() -> Self {
        var copy = self
        copy.moveUp()
        return copy
    }
    
    func right() -> Self {
        var copy = self
        copy.moveRight()
        return copy
    }
    
    func down() -> Self {
        var copy = self
        copy.moveDown()
        return copy
    }
    
    func left() -> Self {
        var copy = self
        copy.moveLeft()
        return copy
    }
    
    func isHasBorderOnTopWith(_ other: Coordinates) -> Bool {
        y - other.y == -1  && isOnSameXAxisWith(other)
    }
    
    func isHasBorderOnDownWith(_ other: Coordinates) -> Bool {
        y - other.y == 1 && isOnSameXAxisWith(other)
    }
    
    func isHasBorderOnLeftWith(_ other: Coordinates) -> Bool {
        x - other.x == 1 && isOnSameYAxisWith(other)
    }
    
    func isHasBorderOnRightWith(_ other: Coordinates) -> Bool {
        x - other.x == -1 && isOnSameYAxisWith(other)
    }
    
    func isOnSameXAxisWith(_ other: Coordinates) -> Bool {
         x == other.x
     }
 
     func isOnSameYAxisWith(_ other: Coordinates) -> Bool {
         y == other.y
     }
    
    func isHasBordersOnLeftOrRightWith(_ other: Coordinates) -> Bool {
        isHasBorderOnRightWith(other) || isHasBorderOnLeftWith(other)
      }
  
    func isHasBordersOnTopOrDownWith(_ other: Coordinates) -> Bool {
          isHasBorderOnTopWith(other) || isHasBorderOnDownWith(other)
      }
    
    func isHasNeighborOnSide(_ side: TileSides, _ other: Coordinates) -> Bool {
        switch side {
        case .upSide:
            return isHasBorderOnTopWith(other)
        case .rightSide:
            return isHasBorderOnRightWith(other)
        case .downSide:
            return isHasBorderOnDownWith(other)
        case .leftSide:
            return isHasBorderOnLeftWith(other)
        case .centre:
            return false
        }
    }
    
    func coordinatesAroundTile() -> [Coordinates] {
        [
            up().left(),   up(),   up().right(),
            left(),        self,   right(),
            down().left(), down(), down().right()
        ]
    }
    
    static func coordinatesAvailableForMeeple() -> [Coordinates] {
        let zero = Self.zero
        return [
            zero.up(),
            zero.left(),
            zero,
            zero.right(),
            zero.down(),
        ]
    }
}

enum MovingDirection: Equatable {
    case up(_ availableToMove: Bool)
    case right(_ availableToMove: Bool)
    case down(_ availableToMove: Bool)
    case left(_ availableToMove: Bool)
}

extension MovingDirection {
    func moveCoordinatesInDirection(coordinates: inout Coordinates) {
        switch self {
        case .up:
            coordinates.moveUp()
        case .right:
            coordinates.moveRight()
        case .down:
            coordinates.moveDown()
        case .left:
            coordinates.moveLeft()
        }
    }
}
