//
//  ViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {

    var game = GameCore() {
        didSet {
            if game.isLastMovingTileCanBePlace {
                game.getMovingTile { tile in
                    tile.tileState = .moving(isOkToPlace: true)
                }
            } else {
                game.getMovingTile { tile in
                    tile.tileState = .moving(isOkToPlace: false)
                }
            }
            let rendering = Rendering(game: self.game, view: mapView)
            rendering.render()
        }
    }
    var mapView = UIScrollView()
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var endTurnAndTakeNewTile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game.tilesStack = TileStorage.tilePool
        mapView = UIScrollView(frame: self.view.bounds)
        mapView.backgroundColor = .white
        mapView.contentSize = CGSize(width: 1000, height: 1000)
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(buttonsView)
        game.tilesOnMap.append(TileStorage.startTile)
    }
    
    
    @IBAction func takeNewTile() {
        game.tileFromStack()
        endTurnAndTakeNewTile.isEnabled = false
    }
    
    @IBAction func placeTile() {
        if game.isLastMovingTileCanBePlace {
            game.placeTileOnMap()
            endTurnAndTakeNewTile.isEnabled = true
        }
    }
    
    @IBAction func moveTileUP() {
        game.getMovingTile { tile in
            tile.moveUp()
        }
    }
    
    @IBAction func moveTileRight() {
        game.getMovingTile { tile in
            tile.moveRight()
        }
    }
    
    @IBAction func moveTileDown() {
        game.getMovingTile { tile in
            tile.moveDown()
        }
    }
    
    @IBAction func moveTileLeft() {
        game.getMovingTile { tile in
            tile.moveLeft()
        }
    }
    
    @IBAction func rotateTileClockwise() {
        game.getMovingTile { tile in
            tile.rotateClockwise()
        }
    }
    
    @IBAction func rotateTileAnticlockwise() {
        game.getMovingTile { tile in
            tile.rotateСounterclockwise()
        }
    }
}

struct Rendering {
    
    var game: GameCore
    var view: UIView
    
    init(game: GameCore, view: UIView) {
        self.game = game
        self.view = view
    }
    
    func render() {
        
        for picture in view.subviews {
            picture.removeFromSuperview()
        }
        
        for tile in game.tilesOnMap {
            let picture = TilePicture(tilePictureName: tile.tilePictureName, view: view)
            picture.possitionInX(coordinatesOfTilesX: tile.coordinates.0)
            picture.possitionInY(coordinateOfTilesY: tile.coordinates.1)
            picture.imageRotationPossition(rotationCalculation: tile.rotationCalculation)
            picture.makeShadow(state: tile.tileState)
            view.addSubview(picture)
        }
        
//        guard let currentTile = game.currentTile else {
//            return
//        }
//
//        let picture = TilePicture(tilePictureName: currentTile.tilePictureName, view: view)
//        picture.possitionInX(coordinatesOfTilesX: currentTile.coordinates.0)
//        picture.possitionInY(coordinateOfTilesY: currentTile.coordinates.1)
//        picture.imageRotationPossition(rotationCalculation: currentTile.rotationCalculation)
//        picture.makeShadow(state: currentTile.tileState)
//        view.addSubview(picture)
    }
}
