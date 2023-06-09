//
//  GameCore.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 07.05.2023.
//

import Foundation


enum GameState {
    case gameStart
    case currentTileOperate(isCanBePlace: Bool)
    case currentTileNotOperate(meepleOperate: MeepleOperate)
    
    enum MeepleOperate {
        case meepleOperate(Bool, Bool)
        case meepleNotOperate
    }
}

protocol CoordinateDelegate {
    func coordinatesChanged(_ coordinates: Coordinates)
}

struct GameCore: CoordinateDelegate {
    var tilesStack = [Tile]()
    var tilesOnMap = [Tile]()
    var currentTile: Tile? = nil {
        didSet {
            guard let currentTile = currentTile else { return }
            isTileCanBePlace = areCoordinatesOkToPlace(currentTileCoordinates: currentTile.coordinates) &&
            areSidesOkToPlace(currentTile: currentTile)
        }
    }
    var players = [Player]()
    private var playerIndex = 0
    
    var movementDirectionsAvailability: [MovingDirection] = [
        .up(true),
        .right(true),
        .down(true),
        .left(true)
    ]
        
    var currentPlayer: Player? {
        players[playerIndex]
    }
    
    
    var unsafeLastTile: Tile {
        get {
            return tilesOnMap[tilesOnMap.count - 1]
        }
        set {
            tilesOnMap[tilesOnMap.count - 1] = newValue
        }
    }
    
    var isTileCanBePlace: Bool = false
        
    var gameState: GameState {
        gameStateChange()
    }

    init(tilesStack: [Tile], firstTile: Tile) {
        self.tilesStack = tilesStack
        
        tilesOnMap.reserveCapacity(tilesStack.count)
        tilesOnMap.append(firstTile)
    }
    
    
    func coordinatesChanged(_ coordinates: Coordinates) {
    }
    
    mutating func tileFromStack() {
        currentTile = tilesStack.removeLast()
        changePlayerIndex()
    }
    
    mutating func placeTileOnMap() {
        guard var currentTile = currentTile else {
            return
        }
        currentTile.belongToPlayer = currentPlayer
        tilesOnMap.append(currentTile)
        self.currentTile = nil
    }
    
    mutating func takeTileBack() {
        currentTile = tilesOnMap.removeLast()
    }
    
    mutating func createMeeple() {
        unsafeLastTile.meeple = Meeple(
            upSide: unsafeLastTile.upSide,
            rightSide: unsafeLastTile.rightSide,
            downSide: unsafeLastTile.downSide,
            leftSide: unsafeLastTile.leftSide,
            centre: unsafeLastTile.centre)
            }
    
    mutating func placeMeeple() {
        if isMeepleFreeToBePlaced() {
            unsafeLastTile.meeple?.isMeeplePlaced = true
        }
    }
    
    mutating func pickUpMeeple() {
        unsafeLastTile.meeple?.isMeeplePlaced = false
    }
    
    mutating func removeMeeple() {
        unsafeLastTile.meeple = nil
    }
    
    func isTileCoordinatesOkToPlace(_ coordinates: Coordinates) -> Bool {
        return tilesOnMap
            .contains(where: { tile in
                coordinates
                    .coordinatesAroundTile()
                    .contains(tile.coordinates)
            })
    }
    
    func isMoveTileOrMeepleCoordinatesOkToPlace(target: TargetControl, mapCoordinates: (Coordinates) -> Coordinates) -> Bool {
        switch target {
        case .tile:
            guard var tileCoordinates = currentTile?.coordinates else {
                return true
            }
            tileCoordinates = mapCoordinates(tileCoordinates)
            return isTileCoordinatesOkToPlace(tileCoordinates)
        case .meeple:
            guard let meeple = unsafeLastTile.meeple else {
                return false
            }
            let meepleCoordinates = mapCoordinates(meeple.coordinates)
            return meeple.isMeepleCoordinatesOkToPlace(meepleCoordinates)
        }
    }
    
    mutating func updateMovementDirectionsAvailability(target: TargetControl) {
        for index in movementDirectionsAvailability.indices {
            switch movementDirectionsAvailability[index] {
            case .up:
                movementDirectionsAvailability[index] = .up(isMoveTileOrMeepleCoordinatesOkToPlace(target: target, mapCoordinates: { $0.up() }))
            case .right:
                movementDirectionsAvailability[index] =
                    .right( isMoveTileOrMeepleCoordinatesOkToPlace(target: target, mapCoordinates: { $0.right() }))
            case .down:
                movementDirectionsAvailability[index] = .down(isMoveTileOrMeepleCoordinatesOkToPlace(target: target, mapCoordinates: { $0.down() }))
            case .left:
                movementDirectionsAvailability[index] = .left(isMoveTileOrMeepleCoordinatesOkToPlace(target: target, mapCoordinates: { $0.left() }))
            }
        }
    }
    
    func isMoveTileOrMeepleIsPossible(givenDirection: MovingDirection) -> Bool {
        for direction in movementDirectionsAvailability {
            if direction == givenDirection {
                switch direction {
                case .up, .right, .down, .left:
                    return true
                }
            }
        }
        return false
    }
    
    func isMeepleFreeToBePlaced() -> Bool {
        var routeIsOk: Bool
//        if let meeple = unsafeLastTile.meeple {

//            switch meeple.positionLandType {
//            case .road(endOfRoad: true):
//                return isRouteFreeForMeepleInOneDirections(startingTile: unsafeLastTile)
//            case .road(endOfRoad: false):
//                return isRouteFreeForMeepleInTwoDirections(startingTile: unsafeLastTile)
//            case .field:
//                return false
//            case .cloister:
//                return true
//            case .city:
//                return true
//            case .crossroads:
//                return false
//            }
//        }
//        return false
        var routeCheck = RoutesChecking(startingTile: unsafeLastTile, listOfTiles: tilesOnMap)
        routeIsOk = routeCheck.isMeepleFreeToBePlaced()
        print(routeCheck.tilesOnRout)
        return routeIsOk
    }
        
}

private extension GameCore {
    
    func gameStateChange() -> GameState {
        if currentTile != nil {
            return .currentTileOperate(isCanBePlace: isTileCanBePlace)
        } else {
            if tilesOnMap.last?.meeple != nil {
                return .currentTileNotOperate(meepleOperate: .meepleOperate(isMeepleFreeToBePlaced(),  unsafeLastTile.meeple?.isMeeplePlaced ?? false))
            } else {
                return .currentTileNotOperate(meepleOperate: .meepleNotOperate)
            }
        }
    }
    
    mutating func changePlayerIndex() {
        if playerIndex == players.count - 1 {
            playerIndex = 0
        } else if playerIndex < players.count - 1 {
            playerIndex += 1
        }
    }
    
    func areCoordinatesOkToPlace(currentTileCoordinates: Coordinates) -> Bool {
        var isCoordinateOkToPlace: Bool = false
        var isXOk = false
        var isYOk = false
        
        for tile in tilesOnMap {

            isYOk = currentTileCoordinates.isHasBordersOnTopOrDownWith(tile.coordinates)

            isXOk = currentTileCoordinates.isHasBordersOnLeftOrRightWith(tile.coordinates)
            
            if isYOk != isXOk {
                break
            }
        }
        
        for tile in tilesOnMap {
            if currentTileCoordinates.isOnSameXAxisWith(tile.coordinates) &&
                currentTileCoordinates.isOnSameYAxisWith(tile.coordinates) {
                isXOk = false
                isYOk = false
            }
        }
        
        if isXOk == isYOk {
            isCoordinateOkToPlace = false
        } else {
            isCoordinateOkToPlace = true
        }
        return isCoordinateOkToPlace
    }
    
    func areSidesOkToPlace(currentTile: Tile) -> Bool {
        var isUpSideOk = true
        var isRightSideOk = true
        var isDownSideOk = true
        var isLeftSideOk = true
        
        for tile in tilesOnMap {
            if currentTile.coordinates.isHasBorderOnTopWith(tile.coordinates) {
                isUpSideOk = tile.downSide == currentTile.upSide
            }
            
            if currentTile.coordinates.isHasBorderOnRightWith(tile.coordinates) {
                isRightSideOk = tile.leftSide == currentTile.rightSide
            }
            
            if currentTile.coordinates.isHasBorderOnDownWith(tile.coordinates) {
                isDownSideOk = tile.upSide == currentTile.downSide
            }
            
            if currentTile.coordinates.isHasBorderOnLeftWith(tile.coordinates) {
                isLeftSideOk = tile.rightSide == currentTile.leftSide
            }
        }
        return isUpSideOk && isRightSideOk && isDownSideOk && isLeftSideOk
    }
//
//    func isRouteFreeForMeepleInTwoDirections(startingTile: Tile) -> Bool {
//        var directionsCheckResults: [Bool] = []
//        let directions = tilesSidesOfRoadDirections(tile: startingTile)
//
//            directionsCheckResults.append(isRoadRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection(tileToCheck: startingTile, routeDirections: directions)))
//        return directionsCheckResults.allSatisfy({$0 == true})
//    }
//    
//    func isRouteFreeForMeepleInOneDirections(startingTile: Tile) -> Bool {
//        return isRoadRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection(tileToCheck: startingTile, routeDirections: [startingTile.meeple!.positionTileSide]))
//    }
//    
//    func isRoadRouteFreeForMeeple(resultOfSideCheck: (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides)) -> Bool {
//        if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == true {
//            return true
//        } else if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == false {
//            return false
//        } else if resultOfSideCheck.tile != nil && resultOfSideCheck.isOk == true {
//            let routeDirection = tilesSidesOfRoadDirectionExceptLast(tile: resultOfSideCheck.tile, exceptedTileSide: resultOfSideCheck.exceptedTileSide)
//            let checkRouteInDirection = checkRouteInDirection(tileToCheck: resultOfSideCheck.tile, routeDirections: routeDirection)
//            return isRoadRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection)
//        }
//        return true
//    }
//    
//    func checkRouteInDirection(tileToCheck: Tile?, routeDirections: [TileSides]) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
//        guard let tile = tileToCheck else { return (nil, false, .upSide)}
//        
//        for direction in routeDirections {
//            switch direction {
//            case .upSide:
//                return checkTileOnDirection(side: .upSide, checkingTile: tile)
//            case .rightSide:
//                return checkTileOnDirection(side: .rightSide, checkingTile: tile)
//            case .downSide:
//                return checkTileOnDirection(side: .downSide, checkingTile: tile)
//            case .leftSide:
//                return checkTileOnDirection(side: .leftSide, checkingTile: tile)
//            case .centre:
//                break
//            }
//        }
//        return (nil, false, .upSide)
//    }
//    
//    func tilesSidesOfRoadDirectionExceptLast(tile: Tile?, exceptedTileSide: TileSides) -> [TileSides] {
//        guard let tile = tile else { return [.centre]}
//        var arrayOfSides = tilesSidesOfRoadDirections(tile: tile)
//                
//        arrayOfSides.removeAll(where: {
//            $0 == exceptedTileSide
//        })
//        
//        return arrayOfSides
//    }
//    
//    func tilesSidesOfRoadDirections(tile: Tile) -> [TileSides] {
//        var tilesRoadsDirections: [TileSides] = []
//        
//        if tile.upSide == .road(endOfRoad: true) {
//            tilesRoadsDirections.append(.upSide)
//        }
//        
//        if tile.rightSide == .road(endOfRoad: true) {
//            tilesRoadsDirections.append(.rightSide)
//        }
//        
//        if tile.downSide == .road(endOfRoad: true) {
//            tilesRoadsDirections.append(.downSide)
//        }
//        
//        if tile.leftSide == .road(endOfRoad: true) {
//            tilesRoadsDirections.append(.leftSide)
//        }
//        
//        return tilesRoadsDirections
//    }
//
//    func checkTileOnDirection(side: TileSides, checkingTile: Tile) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
//        let exceptedSide: TileSides = side.getOppositeSide()
//        for tile in tilesOnMap.dropLast() {
//            if checkingTile.coordinates.isHasNeighborOnSide(side, tile.coordinates) {
//                if let tileMeeple = tile.meeple {
//                    if tileMeeple.positionLandType.isAnotherMeeplePlacable(landTypeToCheck: .road(endOfRoad: false)) {
//                        if tile.getLandTypeForSide(exceptedSide) != .road(endOfRoad: false) {
//                            return (nil, true, exceptedSide)
//                        } else {
//                            return (tile, true, exceptedSide)
//                        }
//                    } else if tileMeeple.positionLandType != .road(endOfRoad: false) {
//                        if tileMeeple.positionTileSide == exceptedSide {
//                            return (nil, false, exceptedSide)
//                        }
//                        return (nil, true, exceptedSide)
//                    }
//                    return (nil, false, exceptedSide)
//                }
//                if tile.getLandTypeForSide(exceptedSide) != .road(endOfRoad: false) {
//                    return (nil, true, exceptedSide)
//                }
//                return (tile, true, exceptedSide)
//            }
//            continue
//        }
//        return (nil, true, exceptedSide)
//    }
}
