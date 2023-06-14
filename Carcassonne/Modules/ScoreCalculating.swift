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
            if tilesOnMap[index].meeple != nil {
                var routeCheck: RoutesChecking?
                switch routeCheckType {
                case .meeplePlacing:
                    break
                case .endOfTurn:
                    routeCheck = RoutesChecking(startingTile: tilesOnMap[index], listOfTiles: tilesOnMap, routeCheckType: routeCheckType)
                case .endOfGame:
                    routeCheck = RoutesChecking(startingTile: tilesOnMap[index], listOfTiles: tilesOnMap, routeCheckType: routeCheckType)
                }
                
                if routeCheck!.isMeepleFreeToBePlaced() {
                    var playersOnRoute: [Player] = []
                    for tileOnRoute in routeCheck!.tilesOnRouteWithMeeple {
                        for tileOnMapIndex in tilesOnMap.indices {
                            if tilesOnMap[tileOnMapIndex] == tileOnRoute {
                                tilesOnMap[tileOnMapIndex] = tileOnRoute
                            }
                        }
                        guard var player = tileOnRoute.belongToPlayer else { break }
                        for playerIndex in players.indices {
                            if players[playerIndex] == player {
                                player = players[playerIndex]
                            }
                        }
                        playersOnRoute.append(player)
                    }
                    for player in whomBelongsRoute(playersOnRoute: playersOnRoute) {
                        switch routeCheck!.typeOfCheckingLand {
                        case .field:
                            break
                        case .cloister:
                            var playerTemp = player
                            playerTemp.score += routeCheck!.tilesOnRout.count
                            findAndReplacePlayer(playerToPlace: playerTemp)
                        case .road:
                            var playerTemp = player
                            playerTemp.score += routeCheck!.tilesOnRout.count
                            findAndReplacePlayer(playerToPlace: playerTemp)
                        case .city:
                            switch routeCheckType {
                            case .meeplePlacing:
                                break
                            case .endOfTurn:
                                var playerTemp = player
                                playerTemp.score += routeCheck!.tilesOnRout.count * 2
                                findAndReplacePlayer(playerToPlace: playerTemp)
                            case .endOfGame:
                                var playerTemp = player
                                playerTemp.score += routeCheck!.tilesOnRout.count
                                findAndReplacePlayer(playerToPlace: playerTemp)
                            }
                            case .crossroads:
                            break
                        }
                    }
//                    print(routeCheck.tilesOnRout.count, routeCheck.tilesOnRouteWithMeeple.count)
                }
            }
        }
    }
    func whomBelongsRoute(playersOnRoute: [Player]) -> [Player] {
        var elementCount = [Player: Int]()

        for player in playersOnRoute {
            elementCount[player, default: 0] += 1
        }

        let maxCount = elementCount.values.max() ?? 0

        let resultArray = elementCount.filter { $0.value >= maxCount }.map { $0.key }

        return resultArray
    }
    
    mutating func findAndReplacePlayer(playerToPlace: Player) {
        for playerIndex in players.indices {
            if players[playerIndex] == playerToPlace {
                players[playerIndex] = playerToPlace
            }
        }
    }
}
