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
    
    func fillUpCoordinatesAroundTile() -> [Coordinates] {
        [
            Coordinates(x: x-1, y: y-1), Coordinates(x: x, y: y+1), Coordinates(x: x+1, y: y+1),
            Coordinates(x: x-1, y: y), Coordinates(x: x, y: y), Coordinates(x: x+1, y: y),
            Coordinates(x: x-1, y: y-1), Coordinates(x: x, y: y-1), Coordinates(x: x+1, y: y-1)
        ]
    }
}

