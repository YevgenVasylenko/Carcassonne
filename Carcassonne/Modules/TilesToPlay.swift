//
//  TilesToPlay.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.04.2023.
//

import Foundation

enum TileStorage {
    static let startTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, centre: .road, tilePictureName: "straightRoadCitySide")
    
    static let tilePool = makeTilePool()
}

// MARK: - Private

private extension TileStorage {
    
    static func makeTilePool() -> [Tile] {
        var tiles = [Tile]()
        tiles += Array(repeating: conerRoadToLeftCitySideTile, count: 3)
        tiles += Array(repeating: conerRoadToRightCitySideTile, count: 3)
        tiles += Array(repeating: tTypeCrossRoadCitySideTile, count: 3)
        tiles += Array(repeating: twoSidesCityWithShieldTile, count: 2)
        tiles += Array(repeating: twoSidesCityTile, count: 2)
        tiles += Array(repeating: twoSideCityWithConerRoadWithShieldTile, count: 2)
        tiles += Array(repeating: twoSideCityWithConerRoadTile, count: 3)
        tiles += Array(repeating: threeSideCityWithShieldTile, count: 1)
        tiles += Array(repeating: threeSideCityTile, count: 3)
        tiles += Array(repeating: threeSideCityWithRoadWithShieldTile, count: 2)
        tiles += Array(repeating: threeSidesCityWithRoadTile, count: 1)
        tiles += Array(repeating: straightRoadTile, count: 9)
        tiles += Array(repeating: conerRoadTile, count: 9)
        tiles += Array(repeating: tTypeConerRoadTile, count: 3)
        tiles += Array(repeating: fourSideCrossRoadTile, count: 1)
        tiles += Array(repeating: straightRoadCitySideTile, count: 4)
        tiles += Array(repeating: citySideTile, count: 5)
        tiles += Array(repeating: tunnelCItyWithShieldTile, count: 2)
        tiles += Array(repeating: tunnelCityTile, count: 1)
        tiles += Array(repeating: twoSidesCitySeparatedTile, count: 3)
        tiles += Array(repeating: twoSideConerCity, count: 2)


        tiles.shuffle()
        return tiles
    }
    
    static let conerRoadToLeftCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .field, leftSide: .road, centre: .road, tilePictureName: "conerRoadToLeftCitySide")

    static let conerRoadToRightCitySideTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .field, centre: .road, tilePictureName: "conerRoadToRightCitySide")

    static let tTypeCrossRoadCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .road, centre: .road, tilePictureName: "tTypeCrossRoadCitySide")

    static let twoSidesCityWithShieldTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .city, centre: .road, tilePictureName: "twoSidesCityWithShield")

    static let twoSidesCityTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .city, centre: .road, tilePictureName: "twoSidesCity")

    static let twoSideCityWithConerRoadWithShieldTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .city, centre: .road, tilePictureName: "twoSideCityWithConerRoadWithShield")

    static let twoSideCityWithConerRoadTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .city, centre: .road, tilePictureName: "twoSideCityWithConerRoad")

    static let threeSideCityWithShieldTile = Tile(upSide: .city, rightSide: .city, downSide: .field, leftSide: .city, centre: .city, tilePictureName: "threeSideCityWithShield")

    static let threeSideCityTile = Tile(upSide: .city, rightSide: .city, downSide: .field, leftSide: .city, centre: .city, tilePictureName: "threeSideCity")

    static let threeSideCityWithRoadWithShieldTile = Tile(upSide: .city, rightSide: .city, downSide: .road, leftSide: .city, centre: .city, tilePictureName: "threeSideCityWithRoadWithShield")

    static let threeSidesCityWithRoadTile = Tile(upSide: .city, rightSide: .city, downSide: .road, leftSide: .city, centre: .city, tilePictureName: "threeSidesCityWithRoad")

    static let citySideTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .field, centre: .field, tilePictureName: "citySide")

    static let cloisterTile = Tile(upSide: .field, rightSide: .field, downSide: .field, leftSide: .field, centre: .cloister, tilePictureName: "cloister")

    static let cloisterWithRoadTile = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .field, centre: .cloister, tilePictureName: "cloisterWithRoad")

    static let conerRoadTile = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .road, centre: .road, tilePictureName: "conerRoad")

    static let fourSideCrossRoadTile = Tile(upSide: .road, rightSide: .road, downSide: .road, leftSide: .road, centre: .road, tilePictureName: "fourSideCrossRoad")

    static let fourSidesCityTile = Tile(upSide: .city, rightSide: .city, downSide: .city, leftSide: .city, centre: .city, tilePictureName: "fourSidesCity")

    static let straightRoadTile = Tile(upSide: .road, rightSide: .field, downSide: .road, leftSide: .field, centre: .road, tilePictureName: "straightRoad")

    static let straightRoadCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, centre: .road, tilePictureName: "straightRoadCitySide")

    static let tTypeConerRoadTile = Tile(upSide: .field, rightSide: .road, downSide: .road, leftSide: .road, centre: .road, tilePictureName: "tTypeConerRoad")

    static let tunnelCItyWithShieldTile = Tile(upSide: .field, rightSide: .city, downSide: .field, leftSide: .city, centre: .city, tilePictureName: "tunnelCItyWithShield")

    static let tunnelCityTile = Tile(upSide: .city, rightSide: .field, downSide: .city, leftSide: .field, centre: .city, tilePictureName: "tunnelCity")

    static let twoSidesCitySeparatedTile = Tile(upSide: .field, rightSide: .city, downSide: .field, leftSide: .city, centre: .field, tilePictureName: "twoSidesCitySeparated")

    static let twoSideConerCity = Tile(upSide: .field, rightSide: .city, downSide: .city, leftSide: .field, centre: .field, tilePictureName: "twoSideConerCity")
}
