//
//  RoutesCheck.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 09.06.2023.
//

import Foundation

struct RoutesChecking {
    
    let startingTile: Tile
    let listOfTiles: [Tile]
    private var typeOfCheckingLand: LandType = .field
    private var exceptedSide: TileSides = .centre
    var tilesOnRout: Int = 0
    
    init(startingTile: Tile, listOfTiles: [Tile]) {
        self.startingTile = startingTile
        self.listOfTiles = listOfTiles
    }
    
    mutating func isMeepleFreeToBePlaced() -> Bool {
        if let meeple = startingTile.meeple {
            
            switch meeple.positionLandType {
            case .road(endOfRoad: true):
                typeOfCheckingLand = .road(endOfRoad: false)
                return isRouteFreeForMeepleInOneDirections(startingTile: startingTile)
            case .road(endOfRoad: false):
                typeOfCheckingLand = .road(endOfRoad: false)
                return isRouteFreeForMeepleInTwoDirections(startingTile: startingTile)
            case .field:
                return false
            case .cloister:
                return true
            case .city(separated: true):
                typeOfCheckingLand = .city(separated: false)
                return isRouteFreeForMeepleInOneDirections(startingTile: startingTile)
            case .city(separated: false):
                typeOfCheckingLand = .city(separated: false)
                return isRouteFreeForMeepleInTwoDirections(startingTile: startingTile)
            case .crossroads:
                return false
            }
        }
        return false
    }
    
    
    mutating func isRouteFreeForMeepleInTwoDirections(startingTile: Tile) -> Bool {
        var directionsCheckResults: [Bool] = []
        let directions = tilesSidesOfRouteDirections(tile: startingTile)
        for direction in directions {
            directionsCheckResults.append(isRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection(tileToCheck: startingTile, routeDirections: direction)))
        }
        return directionsCheckResults.allSatisfy({$0 == true})
    }
    
    mutating func isRouteFreeForMeepleInOneDirections(startingTile: Tile) -> Bool {
        return isRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection(tileToCheck: startingTile, routeDirections: startingTile.meeple!.positionTileSide))
    }
    
    mutating func isRouteFreeForMeeple(resultOfSideCheck: (tile: Tile?, isOk: Bool)) -> Bool {
        if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == true {
            return true
        } else if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == false {
            return false
        } else if resultOfSideCheck.tile != nil && resultOfSideCheck.isOk == true {
            var directionsCheckResults: [Bool] = []
            let routeDirection = tilesSidesOfRoadDirectionExceptLast(tile: resultOfSideCheck.tile)
            for direction in routeDirection {
                let checkRouteInDirection = checkRouteInDirection(tileToCheck: resultOfSideCheck.tile, routeDirections: direction)
                directionsCheckResults.append(isRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection))
            }
            return directionsCheckResults.allSatisfy({$0 == true})
        }
        return true
    }
    
    mutating func checkRouteInDirection(tileToCheck: Tile?, routeDirections: TileSides) -> (tile: Tile?, isOk: Bool) {
        guard let tile = tileToCheck else { return (nil, false)}
        
            switch routeDirections {
            case .upSide:
                updateExceptedSide(side: .upSide)
                return checkTileOnDirection(side: .upSide, checkingTile: tile)
            case .rightSide:
                updateExceptedSide(side: .rightSide)
                return checkTileOnDirection(side: .rightSide, checkingTile: tile)
            case .downSide:
                updateExceptedSide(side: .downSide)
                return checkTileOnDirection(side: .downSide, checkingTile: tile)
            case .leftSide:
                updateExceptedSide(side: .leftSide)
                return checkTileOnDirection(side: .leftSide, checkingTile: tile)
            case .centre:
                break
        }
        return (nil, false)
    }
    
    func tilesSidesOfRoadDirectionExceptLast(tile: Tile?) -> [TileSides] {
        guard let tile = tile else { return [.centre]}
        var arrayOfSides = tilesSidesOfRouteDirections(tile: tile)
                
        arrayOfSides.removeAll(where: {
            $0 == exceptedSide
        })
        
        return arrayOfSides
    }
    
    func tilesSidesOfRouteDirections(tile: Tile) -> [TileSides] {
        var tilesRoadsDirections: [TileSides] = []
        
        if tile.upSide == typeOfCheckingLand {
            tilesRoadsDirections.append(.upSide)
        }
        
        if tile.rightSide == typeOfCheckingLand {
            tilesRoadsDirections.append(.rightSide)
        }
        
        if tile.downSide == typeOfCheckingLand {
            tilesRoadsDirections.append(.downSide)
        }
        
        if tile.leftSide == typeOfCheckingLand {
            tilesRoadsDirections.append(.leftSide)
        }
        
        return tilesRoadsDirections
    }
    
    mutating func updateExceptedSide(side: TileSides) {
        exceptedSide = side.getOppositeSide()
    }

    mutating func checkTileOnDirection(side: TileSides, checkingTile: Tile) -> (tile: Tile?, isOk: Bool) {
        for tile in listOfTiles.dropLast() {
            if checkingTile.coordinates.isHasNeighborOnSide(side, tile.coordinates) {
                tilesOnRout += 1
                if let tileMeeple = tile.meeple {
                    if typeOfCheckingLand.isAnotherMeeplePlacable(landTypeToCheck: tileMeeple.positionLandType) {
                        if tile.getLandTypeForSide(exceptedSide) != typeOfCheckingLand {
                            return (nil, true)
                        } else {
                            return (tile, true)
                        }
                    } else if tileMeeple.positionLandType != typeOfCheckingLand {
                        if tileMeeple.positionTileSide == exceptedSide {
                            return (nil, false)
                        }
                        return (nil, true)
                    }
                    return (nil, false)
                }
                if tile.getLandTypeForSide(exceptedSide) != typeOfCheckingLand {
                    return (nil, true)
                }
                return (tile, true)
            }
            continue
        }
        return (nil, true)
    }
}
