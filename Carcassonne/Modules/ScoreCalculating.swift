//
//  ScoreCalculating.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 09.06.2023.
//

import Foundation

struct ScoreCalculating {
    
    var tilesOnMap: [Tile]
    var players: [Player]
    
    
    init(tileOnMap: [Tile], players: [Player]) {
        self.tilesOnMap = tileOnMap
        self.players = players
    }
    
    mutating func calculateClosedRoutes(routeCheckType: RouteCheckType) {
        for index in tilesOnMap.indices {
            
            guard tilesOnMap[index].meeple != nil else {
                continue
            }
            
            var routeCheck = getRouteCheckDependsOnTypeOfCheck(startingTile: tilesOnMap[index], routeCheckType: routeCheckType)
            
            guard routeCheck.isMeepleFreeToBePlaced() else {
                continue
            }
            
            var playersOnRoute: [Player] = []
            
            for tileOnRoute in routeCheck.tilesOnRouteWithMeeple {
                for tileOnMapIndex in tilesOnMap.indices {
                    if tilesOnMap[tileOnMapIndex] == tileOnRoute {
                        tilesOnMap[tileOnMapIndex] = tileOnRoute
                    }
                }
                guard var player = tileOnRoute.belongToPlayer else { break }
                for playerIndex in players.indices {
                    if players[playerIndex] == player {
                        player = players[playerIndex]
                        player.availableMeeples += 1
                        players[playerIndex] = player
                    }
                }
            }

            for tileOnRoute in routeCheck.tilesOnRouteWithMeeple {
                guard var player = tileOnRoute.belongToPlayer else { break }

                for playerIndex in players.indices {
                    if players[playerIndex] == player {
                        player = players[playerIndex]
                    }
                }
                playersOnRoute.append(player)
            }
            
            for player in whomBelongsRoute(playersOnRoute: playersOnRoute) {
                switch routeCheck.typeOfCheckingLand {
                case .field:
                    break
                case .cloister:
                    findAndReplacePlayer(
                        playerToPlace: addScorePointsToPlayer(
                            points: routeCheck.tilesOnRout.count,
                            player: player))
                case .road:
                    findAndReplacePlayer(
                        playerToPlace: addScorePointsToPlayer(
                            points: routeCheck.tilesOnRout.count,
                            player: player))
                case .city:
                    switch routeCheckType {
                    case .meeplePlacing:
                        break
                    case .endOfTurn:
                        findAndReplacePlayer(
                            playerToPlace: addScorePointsToPlayer(
                                points: routeCheck.tilesOnRout.count * 2 + getArmedTiles(tiles: routeCheck.tilesOnRout).count * 2,
                                player: player))
                    case .endOfGame:
                        findAndReplacePlayer(
                            playerToPlace: addScorePointsToPlayer(
                                points: routeCheck.tilesOnRout.count + getArmedTiles(tiles: routeCheck.tilesOnRout).count * 2,
                                player: player))
                    }
                case .crossroads:
                    break
                }
            }
        }
    }
    
    func getRouteCheckDependsOnTypeOfCheck(startingTile: Tile, routeCheckType: RouteCheckType) -> RoutesChecking {
        switch routeCheckType {
        case .meeplePlacing:
            fatalError()
        case .endOfTurn:
            return RoutesChecking(startingTile: startingTile, listOfTiles: tilesOnMap, routeCheckType: routeCheckType)
        case .endOfGame:
            return RoutesChecking(startingTile: startingTile, listOfTiles: tilesOnMap, routeCheckType: routeCheckType)
        }
    }
    
    func whomBelongsRoute(playersOnRoute: [Player]) -> [Player] {
        var playerCount = [Player: Int]()

        for player in playersOnRoute {
            playerCount[player, default: 0] += 1
        }

        let maxCount = playerCount.values.max() ?? 0

        let resultArray = playerCount.filter { $0.value >= maxCount }.map { $0.key }

        return resultArray
    }
    
    mutating func findAndReplacePlayer(playerToPlace: Player) {
        for playerIndex in players.indices {
            if players[playerIndex] == playerToPlace {
                players[playerIndex] = playerToPlace
            }
        }
    }
    
    func addScorePointsToPlayer(points: Int, player: Player) -> Player {
        var tempPlayer = player
        tempPlayer.score += points
        return tempPlayer
    }
    
    func getArmedTiles(tiles: Set<Tile>) -> [Tile] {
        var armedTiles: [Tile] = []
        for tile in tiles {
            if tile.isTileArmed == true {
                armedTiles.append(tile)
            }
        }
        return armedTiles
    }
}
