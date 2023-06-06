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

struct GameCore {
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
        
    var controlledMeeple: Meeple? =  nil {
        didSet {
            let result = checkRouteInDirection(tileToCheck: unsafeLastTile, routeDirections: tilesRoadDirections(tile: (unsafeLastTile)))
            print(isRoadRouteFreeForMeeple(resultOfSideCheck: result))
        }
    }
    
    var gameState: GameState {
        gameStateChange()
    }

    init(tilesStack: [Tile], firstTile: Tile) {
        self.tilesStack = tilesStack
        
        tilesOnMap.reserveCapacity(tilesStack.count)
        tilesOnMap.append(firstTile)
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
        
        controlledMeeple = unsafeLastTile.meeple
    }
    
    mutating func placeMeeple() {
        if unsafeLastTile.meeple?.isMeepleOnField ?? false {
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
}

private extension GameCore {
    
    func gameStateChange() -> GameState {
        if currentTile != nil {
            return .currentTileOperate(isCanBePlace: isTileCanBePlace)
        } else {
            if tilesOnMap.last?.meeple != nil {
                return .currentTileNotOperate(meepleOperate: .meepleOperate(unsafeLastTile.meeple?.isMeepleOnField ?? false,  unsafeLastTile.meeple?.isMeeplePlaced ?? false))
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

            isYOk = currentTileCoordinates.isYAxisNeighbour(tile.coordinates)

            isXOk = currentTileCoordinates.isXAxisNeighbour(tile.coordinates)
            
            if isYOk != isXOk {
                break
            }
        }
        
        for tile in tilesOnMap {
            if currentTileCoordinates.isOnSameXAxis(tile.coordinates) &&
                currentTileCoordinates.isOnSameYAxis(tile.coordinates) {
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
            if currentTile.coordinates.isUpNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameXAxis(tile.coordinates) {
                isUpSideOk = tile.downSide == currentTile.upSide
            }
            
            if currentTile.coordinates.isRightNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameYAxis(tile.coordinates) {
                isRightSideOk = tile.leftSide == currentTile.rightSide
            }
            
            if currentTile.coordinates.isDownNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameXAxis(tile.coordinates) {
                isDownSideOk = tile.upSide == currentTile.downSide
            }
            
            if currentTile.coordinates.isLeftNeighbour(tile.coordinates) &&
                currentTile.coordinates.isOnSameYAxis(tile.coordinates) {
                isLeftSideOk = tile.rightSide == currentTile.leftSide
            }
        }
        return isUpSideOk && isRightSideOk && isDownSideOk && isLeftSideOk
    }

//    func roadRouteChek() -> Bool {
//        var startTile: Tile? = unsafeLastTile
//        for tileSide in tilesRoadDirections(tile: startTile) {
//            if tileSide == .upSide {
//                startTile = checkTileOnTop(startTile: startTile)
//            }
//        }
//    }
    
    func isRoadRouteFreeForMeeple(resultOfSideCheck: (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides)) -> Bool {
        if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == true {
            return true
        } else if resultOfSideCheck.tile == nil && resultOfSideCheck.isOk == false {
            return false
        } else if resultOfSideCheck.tile != nil && resultOfSideCheck.isOk == true {
            let routeDirections = tilesRoadDirectionsExceptLast(tile: resultOfSideCheck.tile, exceptedTileSide: resultOfSideCheck.exceptedTileSide)
            let checkRouteInDirection = checkRouteInDirection(tileToCheck: resultOfSideCheck.tile, routeDirections: routeDirections)
            return isRoadRouteFreeForMeeple(resultOfSideCheck: checkRouteInDirection)
        }
        return true
    }
    
    func checkRouteInDirection(tileToCheck: Tile?, routeDirections: [TileSides]) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
        guard let tile = tileToCheck else { return (nil, false, .upSide)}
        for index in routeDirections.indices {
            switch routeDirections[index] {
                
            case .upSide:
                return checkTileOnTop(checking: tile)
            case .rightSide:
                break
            case .downSide:
                break
            case .leftSide:
                break
            case .centre:
                break
            }
        }
        return checkTileOnTop(checking: tile)
    }
    
    func tilesRoadDirectionsExceptLast(tile: Tile?, exceptedTileSide: TileSides?) -> [TileSides] {
        guard let tile = tile else { return [] }
        var arrayOfSides = tilesRoadDirections(tile: tile)
        
        guard let tileSide = exceptedTileSide else { return arrayOfSides }
        
        for index in arrayOfSides.indices {
            if arrayOfSides[index] == tileSide {
                arrayOfSides.remove(at: index)
                return arrayOfSides
            }
        }
        return arrayOfSides
    }
    
    func tilesRoadDirections(tile: Tile) -> [TileSides] {
        var tilesRoadsDirections: [TileSides] = []
        
        if tile.upSide == .road(endOfRoad: true) || tile.upSide == .road(endOfRoad: false) {
            tilesRoadsDirections.append(.upSide)
        }
        
        if tile.rightSide == .road(endOfRoad: true) || tile.rightSide == .road(endOfRoad: false) {
            tilesRoadsDirections.append(.rightSide)
        }
        
        if tile.downSide == .road(endOfRoad: true) || tile.downSide == .road(endOfRoad: false) {
            tilesRoadsDirections.append(.downSide)
        }
        
        if tile.leftSide == .road(endOfRoad: true) || tile.leftSide == .road(endOfRoad: false) {
            tilesRoadsDirections.append(.leftSide)
        }
        
        return tilesRoadsDirections
    }
    
    
    func checkTileOnTop(checking: Tile) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
        let exceptedSide: TileSides = .downSide
        for tile in tilesOnMap {
            if checking.coordinates.isUpNeighbour(tile.coordinates) && checking.coordinates.isOnSameXAxis(tile.coordinates) {
                if let tileMeeple = tile.meeple {
                    if tileMeeple.positionLandType == .city || tileMeeple.positionLandType == .cloister {
                        if tile.downSide != .road(endOfRoad: false) {
                            return (nil, true, exceptedSide)
                        } else {
                            return (tile, true, exceptedSide)
                        }
                    } else if tileMeeple.positionLandType != .road(endOfRoad: false) {
                        if tileMeeple.positionTileSide == .downSide {
                            return (nil, false, exceptedSide)
                        }
                        return (nil, true, exceptedSide)
                    }
                    return (nil, false, exceptedSide)
                }
                return (tile, true, exceptedSide)
            }
            continue
        }
        return (nil, true, exceptedSide)
    }
    
    func checkTileOnRight(checking: Tile) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
        let exceptedSide: TileSides = .leftSide
        for tile in tilesOnMap {
            if checking.coordinates.isRightNeighbour(tile.coordinates) && checking.coordinates.isOnSameYAxis(tile.coordinates) {
                if let tileMeeple = tile.meeple {
                    if tileMeeple.positionLandType == .city || tileMeeple.positionLandType == .cloister {
                        if tile.leftSide != .road(endOfRoad: false) {
                            return (nil, true, exceptedSide)
                        } else {
                            return (tile, true, exceptedSide)
                        }
                    } else if tileMeeple.positionLandType != .road(endOfRoad: false) {
                        if tileMeeple.positionTileSide == .leftSide {
                            return (nil, false, exceptedSide)
                        }
                        return (nil, true, exceptedSide)
                    }
                    return (nil, false, exceptedSide)
                }
                return (tile, true, exceptedSide)
            }
            continue
        }
        return (nil, true, exceptedSide)
    }
    
    func checkTileOnDown(checking: Tile) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
        let exceptedSide: TileSides = .upSide
        for tile in tilesOnMap {
            if checking.coordinates.isRightNeighbour(tile.coordinates) && checking.coordinates.isOnSameYAxis(tile.coordinates) {
                if let tileMeeple = tile.meeple {
                    if tileMeeple.positionLandType == .city || tileMeeple.positionLandType == .cloister {
                        if tile.upSide != .road(endOfRoad: false) {
                            return (nil, true, exceptedSide)
                        } else {
                            return (tile, true, exceptedSide)
                        }
                    } else if tileMeeple.positionLandType != .road(endOfRoad: false) {
                        if tileMeeple.positionTileSide == .upSide {
                            return (nil, false, exceptedSide)
                        }
                        return (nil, true, exceptedSide)
                    }
                    return (nil, false, exceptedSide)
                }
                return (tile, true, exceptedSide)
            }
            continue
        }
        return (nil, true, exceptedSide)
    }
    
    func checkTileOnLeft(checking: Tile) -> (tile: Tile?, isOk: Bool, exceptedTileSide: TileSides) {
        let exceptedSide: TileSides = .rightSide
        for tile in tilesOnMap {
            if checking.coordinates.isRightNeighbour(tile.coordinates) && checking.coordinates.isOnSameYAxis(tile.coordinates) {
                if let tileMeeple = tile.meeple {
                    if tileMeeple.positionLandType == .city || tileMeeple.positionLandType == .cloister {
                        if tile.rightSide != .road(endOfRoad: false) {
                            return (nil, true, exceptedSide)
                        } else {
                            return (tile, true, exceptedSide)
                        }
                    } else if tileMeeple.positionLandType != .road(endOfRoad: false) {
                        if tileMeeple.positionTileSide == .rightSide {
                            return (nil, false, exceptedSide)
                        }
                        return (nil, true, exceptedSide)
                    }
                    return (nil, false, exceptedSide)
                }
                return (tile, true, exceptedSide)
            }
            continue
        }
        return (nil, true, exceptedSide)
    }
}
