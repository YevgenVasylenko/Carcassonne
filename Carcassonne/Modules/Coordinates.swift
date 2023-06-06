//
//  Coordinates.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 23.05.2023.
//

import Foundation

struct Coordinates: Equatable {
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
    
    func isUpNeighbour(_ other: Coordinates) -> Bool {
        y - other.y == -1
    }
    
    func isDownNeighbour(_ other: Coordinates) -> Bool {
        y - other.y == 1
    }
    
    func isLeftNeighbour(_ other: Coordinates) -> Bool {
        x - other.x == 1
    }
    
    func isRightNeighbour(_ other: Coordinates) -> Bool {
        x - other.x == -1
    }
    
    func isOnSameXAxis(_ other: Coordinates) -> Bool {
         x == other.x
     }
 
     func isOnSameYAxis(_ other: Coordinates) -> Bool {
         y == other.y
     }
    
    func isXAxisNeighbour(_ other: Coordinates) -> Bool {
          (isLeftNeighbour(other) || isRightNeighbour(other)) && isOnSameYAxis(other)
      }
  
    func isYAxisNeighbour(_ other: Coordinates) -> Bool {
          (isUpNeighbour(other) || isDownNeighbour(other)) && isOnSameXAxis(other)
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
