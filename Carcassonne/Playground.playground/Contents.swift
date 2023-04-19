import UIKit

var startTile = Tile(upSide: .road, rightSide: .city, downSide: .road, leftSide: .field, center: .road, coordinates: (0, 0))

var citySideTile = Tile(upSide: .city, rightSide: .field, downSide: .field, leftSide: .field, center: .field, coordinates: (0, 0))

var cloister = Tile(upSide: .field, rightSide: .field, downSide: .field, leftSide: .field, center: .cloister, coordinates: (0,0))

var cloisterWithRoad = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .field, center: .cloister, coordinates: (0, 0))

var conerRoad = Tile(upSide: .field, rightSide: .field, downSide: .road, leftSide: .road, center: .road, coordinates: (0, 0))

var conerRoadToLeftCitySide = Tile(upSide: .road, rightSide: .city, downSide: .field, leftSide: .road, center: .road, coordinates: (0, 0))

var conerRoadToRightCitySide = Tile(upSide: .city, rightSide: .road, downSide: .road, leftSide: .field, center: .road, coordinates: (0, 0))

var game = LandScape(tilesStack: [citySideTile, cloister, cloisterWithRoad, conerRoad, conerRoadToLeftCitySide, conerRoadToRightCitySide])

game.tilesOnMap.append(startTile)
game.tileFromStack()
game.currentTile?.moveLeft()
game.placeTileOnMap()
