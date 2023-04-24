import UIKit

var startTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, center: .road, coordinates: (0, 0), tilePictureName: "")

var citySideTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .field, center: .field, coordinates: (0, 0), tilePictureName: "")

var cloister = Tile(upSide: .field, rightSide: .field, downSide: .field, leftSide: .field, center: .cloister, coordinates: (0,0), tilePictureName: "")

var cloisterWithRoad = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .field, center: .cloister, coordinates: (0, 0), tilePictureName: "")

var conerRoad = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .road, center: .road, coordinates: (0, 0), tilePictureName: "")

var conerRoadToLeftCitySide = Tile(upSide: .road, rightSide: .city, downSide: .field, leftSide: .road, center: .road, coordinates: (0, 0), tilePictureName: "")

let conerRoadToRightCitySide = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .field, center: .road, coordinates: (0, 0), tilePictureName: "")

var game = LandScape(tilesStack: [citySideTile, cloister, cloisterWithRoad, conerRoad, conerRoadToLeftCitySide, conerRoadToRightCitySide, cloister])

game.tilesOnMap.append(startTile)
game.tileFromStack()
game.currentTile?.moveRight()
game.currentTile?.moveUp()
game.placeTileOnMap()


