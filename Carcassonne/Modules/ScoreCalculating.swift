//
//  ScoreCalculating.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 09.06.2023.
//

import Foundation

struct ScoreCalculating {
    
    let tileOnMap: [Tile]
    
    init(tileOnMap: [Tile]) {
        self.tileOnMap = tileOnMap
    }
    
    func calculateClosedRoutes() {
        for tile in tileOnMap {
            if tile.meeple != nil {
                let routeCheck = RoutesChecking(startingTile: tile, listOfTiles: tileOnMap, routeCheckType: .endOfTurn)
                
            }
        }
    }
}
