//
//  TilesToPlay.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.04.2023.
//

import Foundation

var TilesToPlay: [Tile] = [conerRoadToLeftCitySideTile, conerRoadToLeftCitySideTile, conerRoadToLeftCitySideTile, conerRoadToRightCitySideTile, conerRoadToRightCitySideTile, conerRoadToRightCitySideTile, tTypeCrossRoadCitySideTile, tTypeCrossRoadCitySideTile, tTypeCrossRoadCitySideTile, twoSidesCityWithShieldTile, twoSidesCityWithShieldTile, twoSidesCityTile, twoSidesCityTile, twoSideCityWithConerRoadWithShieldTile, twoSideCityWithConerRoadWithShieldTile, twoSideCityWithConerRoadTile, twoSideCityWithConerRoadTile, twoSideCityWithConerRoadTile, threeSideCityWithShieldTile, threeSideCityTile, threeSideCityTile, threeSideCityTile, threeSideCityWithRoadWithShieldTile, threeSideCityWithRoadWithShieldTile, threeSidesCityWithRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, straightRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, conerRoadTile, tTypeConerRoadTile, tTypeConerRoadTile, tTypeConerRoadTile, fourSideCrossRoadTile, cloisterWithRoadTile, cloisterWithRoadTile, cloisterTile, cloisterTile, cloisterTile, cloisterTile, fourSidesCityTile, straightRoadCitySideTile, straightRoadCitySideTile, straightRoadCitySideTile, straightRoadCitySideTile, citySideTile, citySideTile, citySideTile, citySideTile, citySideTile, tunnelCItyWithShieldTile, tunnelCItyWithShieldTile, tunnelCityTile, twoSidesCitySeparatedTile, twoSidesCitySeparatedTile, twoSidesCitySeparatedTile, twoSideConerCity, twoSideConerCity]

let conerRoadToLeftCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .field, leftSide: .road, center: .road, tilePictureName: "conerRoadToLeftCitySide")

let conerRoadToRightCitySideTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .field, center: .road, tilePictureName: "conerRoadToRightCitySide")

let tTypeCrossRoadCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .road, center: .road, tilePictureName: "tTypeCrossRoadCitySide")

let twoSidesCityWithShieldTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .city, center: .road, tilePictureName: "twoSidesCityWithShield")

let twoSidesCityTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .city, center: .road, tilePictureName: "twoSidesCity")

let twoSideCityWithConerRoadWithShieldTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .city, center: .road, tilePictureName: "twoSideCityWithConerRoadWithShield")

let twoSideCityWithConerRoadTile = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .city, center: .road, tilePictureName: "twoSideCityWithConerRoad")

let threeSideCityWithShieldTile = Tile(upSide: .city, rightSide: .city, downSide: .field, leftSide: .city, center: .city, tilePictureName: "threeSideCityWithShield")

let threeSideCityTile = Tile(upSide: .city, rightSide: .city, downSide: .field, leftSide: .city, center: .city, tilePictureName: "threeSideCity")

let threeSideCityWithRoadWithShieldTile = Tile(upSide: .city, rightSide: .city, downSide: .road, leftSide: .city, center: .city, tilePictureName: "threeSideCityWithRoadWithShield")

let threeSidesCityWithRoadTile = Tile(upSide: .city, rightSide: .city, downSide: .road, leftSide: .city, center: .city, tilePictureName: "threeSidesCityWithRoad")

let citySideTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .field, center: .field, tilePictureName: "citySide")

let cloisterTile = Tile(upSide: .field, rightSide: .field, downSide: .field, leftSide: .field, center: .cloister, tilePictureName: "cloister")

let cloisterWithRoadTile = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .field, center: .cloister, tilePictureName: "cloisterWithRoad")

let conerRoadTile = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .road, center: .road, tilePictureName: "conerRoad")

let fourSideCrossRoadTile = Tile(upSide: .road, rightSide: .road, downSide: .road, leftSide: .road, center: .road, tilePictureName: "fourSideCrossRoad")

let fourSidesCityTile = Tile(upSide: .city, rightSide: .city, downSide: .city, leftSide: .city, center: .city, tilePictureName: "fourSidesCity")

let straightRoadTile = Tile(upSide: .road, rightSide: .field, downSide: .road, leftSide: .field, center: .road, tilePictureName: "straightRoad")

let straightRoadCitySideTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, center: .road, tilePictureName: "straightRoadCitySide")

let tTypeConerRoadTile = Tile(upSide: .field, rightSide: .road, downSide: .road, leftSide: .road, center: .road, tilePictureName: "tTypeConerRoad")

let tunnelCItyWithShieldTile = Tile(upSide: .field, rightSide: .city, downSide: .field, leftSide: .city, center: .city, tilePictureName: "tunnelCItyWithShield")

let tunnelCityTile = Tile(upSide: .city, rightSide: .field, downSide: .city, leftSide: .field, center: .city, tilePictureName: "tunnelCity")

let twoSidesCitySeparatedTile = Tile(upSide: .field, rightSide: .city, downSide: .field, leftSide: .city, center: .field, tilePictureName: "twoSidesCitySeparated")

let twoSideConerCity = Tile(upSide: .field, rightSide: .city, downSide: .city, leftSide: .field, center: .field, tilePictureName: "twoSideConerCity")

let startTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, center: .road, tilePictureName: "straightRoadCitySide")
