//
//  RoutesCheck.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 09.06.2023.
//
import Foundation


enum RouteCheckType {
    case meeplePlacing
    case endOfTurn
    case endOfGame
}

struct RoutesChecking {
    
    private let startingTile: Tile
    private let listOfTiles: [Tile]
    private let routeCheckType: RouteCheckType
    var typeOfCheckingLand: LandType = .field
    private var exceptedSide: TileSides = .centre
    var tilesOnRouteWithMeeple: [Tile] = []
    var tilesOnRout: Set<Tile> = []
    var playersMeeples: [Player] = []
    
    init(startingTile: Tile, listOfTiles: [Tile], routeCheckType: RouteCheckType) {
        self.startingTile = startingTile
        self.listOfTiles = listOfTiles
        self.routeCheckType = routeCheckType
    }
    
    mutating func isMeepleFreeToBePlaced() -> Bool {
        var tileToChange = startingTile
        tileToChange.meeple = nil
        tilesOnRouteWithMeeple.append(tileToChange)
        tilesOnRout.insert(startingTile)
        if let meeple = startingTile.meeple {
            switch meeple.positionLandType {
            case .road(endOfRoad: true):
                typeOfCheckingLand = .road(endOfRoad: false)
                return isRouteFreeForMeepleInDirections(startingTile: startingTile)
            case .road(endOfRoad: false):
                typeOfCheckingLand = .road(endOfRoad: false)
                return isRouteFreeForMeepleInDirections(startingTile: startingTile)
            case .field:
                return false
            case .cloister:
                typeOfCheckingLand = .cloister
                return isCloisterSurrounded()
            case .city(separated: true):
                typeOfCheckingLand = .city(separated: false)
                return isRouteFreeForMeepleInDirections(startingTile: startingTile)
            case .city(separated: false):
                typeOfCheckingLand = .city(separated: false)
                return isRouteFreeForMeepleInDirections(startingTile: startingTile)
            case .crossroads:
                return false
            }
        }
        return false
    }
    
    
    mutating func isRouteFreeForMeepleInDirections(startingTile: Tile) -> Bool {
        var directionsCheckResults: [Bool] = []
        let directions = tilesSidesOfRoadDirectionExceptLast(tile: startingTile)
        for direction in directions {
            directionsCheckResults.append(isRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection(tileToCheck: startingTile, routeDirections: direction)))
        }
        return directionsCheckResults.allSatisfy({$0 == true})
    }
    
    mutating func isRouteFreeForMeeple(resultOfSideCheck: (tile: Tile?, isOk: Bool)) -> Bool {
        if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == true {
            return true
        } else if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == false {
            return false
        } else if resultOfSideCheck.tile != nil && resultOfSideCheck.isOk == true {
            if let tile = resultOfSideCheck.tile {
                return isRouteFreeForMeepleInDirections(startingTile: tile)
            }
        }
        return true
    }
    
    mutating func checkRouteInDirection(tileToCheck: Tile?, routeDirections: TileSides) -> (tile: Tile?, isOk: Bool) {
        guard let tile = tileToCheck else { return (nil, false)}
        
        switch routeDirections {
        case .upSide:
            updateExceptedSide(side: .upSide)
            return checkingTileOnDirectionNew(side: .upSide, checkingTile: tile)
        case .rightSide:
            updateExceptedSide(side: .rightSide)
            return checkingTileOnDirectionNew(side: .rightSide, checkingTile: tile)
        case .downSide:
            updateExceptedSide(side: .downSide)
            return checkingTileOnDirectionNew(side: .downSide, checkingTile: tile)
        case .leftSide:
            updateExceptedSide(side: .leftSide)
            return checkingTileOnDirectionNew(side: .leftSide, checkingTile: tile)
        case .centre:
            break
        }
        return (nil, false)
    }
    
    func tilesSidesOfRoadDirectionExceptLast(tile: Tile?) -> [TileSides] {
        guard let tile = tile else { return [.centre] }
        var arrayOfSides = tilesSidesOfRouteDirections(tile: tile)
        
        arrayOfSides.removeAll(where: {
            $0 == exceptedSide
        })
        
        return arrayOfSides
    }
    
    func tilesSidesOfRouteDirections(tile: Tile) -> [TileSides] {
        var tilesRoadsDirections: [TileSides] = []
        
        if let tileMeeple = tile.meeple {
            if tileMeeple.positionLandType != typeOfCheckingLand && tileMeeple.positionLandType == typeOfCheckingLand {
                tilesRoadsDirections.append(tileMeeple.positionTileSide)
                return tilesRoadsDirections
            }
        }
        
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
    
    mutating func checkingTileOnDirectionNew(side: TileSides, checkingTile: Tile) -> (tile: Tile?, isOk: Bool) {
        for tile in listOfTiles {
            
            if checkingTile.coordinates.isHasNeighborOnSide(side, tile.coordinates) && !tilesOnRout.contains(tile) {
                
                if !tilesOnRout.contains(tile) {
                    tilesOnRout.insert(tile)
                }
                
                if tile.getLandTypeForSide(exceptedSide) != typeOfCheckingLand {
                    if tile.meeple?.positionTileSide == exceptedSide {
                        switch routeCheckType {
                        case .meeplePlacing:
                            return (nil, false)
                        case .endOfTurn:
                            var tileToChange = tile
                            tileToChange.meeple = nil
                            tilesOnRouteWithMeeple.append(tileToChange)
                            return (nil, true)
                        case .endOfGame:
                            return (nil, true)
                        }
                    }
                    return (nil, true)
                }
                if let tileMeeple = tile.meeple {
                    if typeOfCheckingLand.isAnotherMeeplePlacable(landTypeToCheck: tileMeeple.positionLandType) {
                        return (tile, true)
                    }
                    switch routeCheckType {
                    case .meeplePlacing:
                        return (nil, false)
                    case .endOfTurn:
                        var tileToChange = tile
                        tileToChange.meeple = nil
                        tilesOnRouteWithMeeple.append(tileToChange)
                        return (tile, true)
                    case .endOfGame:
                        var tileToChange = tile
                        tileToChange.meeple = nil
                        tilesOnRouteWithMeeple.append(tileToChange)
                        return (tile, true)
                    }
                }
                return (tile, true)
            }
            switch routeCheckType {
            case .meeplePlacing:
                continue
            case .endOfTurn:
                if checkingTile.coordinates.isHasNeighborOnSide(side, tile.coordinates) && tilesOnRout.contains(tile)  {
                    if startingTile.meeple?.positionLandType == .road(endOfRoad: true) {
                        return (nil, true)
                    }
                    if startingTile.meeple?.positionLandType == .city(separated: true) {
                        return (nil, true)
                    }
                }
            case .endOfGame:
                continue
            }
        }
        switch routeCheckType {
        case .meeplePlacing:
            return (nil, true)
        case .endOfTurn:
            return (nil, false)
        case .endOfGame:
            return (nil, true)
        }
    }
    
    mutating func isCloisterSurrounded() -> Bool {
        switch routeCheckType {
        case .meeplePlacing:
            return true
        case .endOfTurn:
            for tile in listOfTiles {
                if startingTile.coordinates.coordinatesAroundTile().contains(tile.coordinates) {
                    tilesOnRout.insert(tile)
                }
            }
            return tilesOnRout.count == 9
        case .endOfGame:
            for tile in listOfTiles {
                if startingTile.coordinates.coordinatesAroundTile().contains(tile.coordinates) {
                    tilesOnRout.insert(tile)
                }
            }
            return true
        }
    }
}
