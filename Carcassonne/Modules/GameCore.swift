//
//  GameCore.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 07.05.2023.
//

import Foundation
import SQLite

enum GameState: Codable {
    case gameStart
    case currentTileOperate(isCanBePlace: Bool)
    case currentTileNotOperate(meepleOperate: MeepleOperate)
    
    enum MeepleOperate: Codable {
        case meepleOperate(Bool, Bool)
        case meepleNotOperate
    }
}

struct GameCore: Codable {
    var id = UUID()
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
#warning("cache not let")
    private var cache = Cache()
    
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
            cache.isMeepleFreeToBePlaced = nil
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
    
    mutating func endOfTurnTakeNewTile() {
        var checkClosedRoutesAndScoreIt = ScoreCalculating(tileOnMap: tilesOnMap, players: players)
      
        if !tilesStack.isEmpty {
            checkClosedRoutesAndScoreIt.calculateClosedRoutes(routeCheckType: .endOfTurn)
            
            switch gameState {
            case .gameStart:
                playerIndex = 0
            case .currentTileOperate:
                changePlayerIndex()
            case .currentTileNotOperate:
                changePlayerIndex()
            }
            
            currentTile = tilesStack.removeLast()
            
        } else {
            checkClosedRoutesAndScoreIt.calculateClosedRoutes(routeCheckType: .endOfGame)
        }
        
        tilesOnMap = checkClosedRoutesAndScoreIt.tilesOnMap
        players = checkClosedRoutesAndScoreIt.players
        GameCoreDAO.saveOrUpdateGame(game: self)
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
        guard !isNoMoreMeeples(player: players[playerIndex]) else { return }
        unsafeLastTile.meeple = Meeple(
            upSide: unsafeLastTile.upSide,
            rightSide: unsafeLastTile.rightSide,
            downSide: unsafeLastTile.downSide,
            leftSide: unsafeLastTile.leftSide,
            centre: unsafeLastTile.centre)
        unsafeLastTile.belongToPlayer = players[playerIndex]
        players[playerIndex].availableMeeples -= 1
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
        if unsafeLastTile.meeple != nil {
            unsafeLastTile.meeple = nil
            unsafeLastTile.belongToPlayer = nil
            players[playerIndex].availableMeeples += 1
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
        if let isOk = cache.isMeepleFreeToBePlaced {
            return isOk
        }
        var routeCheck = RoutesChecking(startingTile: unsafeLastTile, listOfTiles: tilesOnMap, routeCheckType: .meeplePlacing)
        let result = routeCheck.isMeepleFreeToBePlaced()
        cache.isMeepleFreeToBePlaced = result
        return result
    }
}

private extension GameCore {
    
    func gameStateChange() -> GameState {
        if tilesOnMap.count == 1 && currentTile == nil {
            return .gameStart
        }
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

            isYOk = currentTileCoordinates
                .isHasBordersOnTopOrDownWith(tile.coordinates)

            isXOk = currentTileCoordinates
                .isHasBordersOnLeftOrRightWith(tile.coordinates)
            
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
    
    func isNoMoreMeeples(player: Player) -> Bool {
        return player.availableMeeples == 0
    }
}

private extension GameCore {
    final class Cache: Codable {
        var isMeepleFreeToBePlaced: Bool?
    }
}

extension GameCore: Value {
    public static var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ blobValue: Blob) -> GameCore {
        let data = Data.fromDatatypeValue(blobValue)
        return try! JSONDecoder().decode(GameCore.self, from: data)
    }
    
    public var datatypeValue: Blob {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return Blob(bytes: [UInt8](data))
    }

}
