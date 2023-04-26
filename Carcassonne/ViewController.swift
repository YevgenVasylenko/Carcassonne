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
        game.tilesOnMap.append(TileStorage.startTile)
//        game.tileFromStack()
        mapView = UIScrollView(frame: self.view.bounds)
        mapView.backgroundColor = .white
        mapView.contentSize = CGSize(width: 1000, height: 1000)
        self.view.addSubview(mapView)
//        picture = TilePicture(tilePictureName:
//                                game.currentTile!.tilePictureName, view: mapView)
//        mapView.addSubview(picture!)
        self.view.bringSubviewToFront(buttonsView)
    }
    
    
    @IBAction func takeNewTile() {
        game.tileFromStack()
//        picture = TilePicture(tilePictureName: game.currentTile!.tilePictureName, view: mapView)
//        mapView.addSubview(picture!)
//        picture?.makeRedSignal(shadowColor: .systemRed)
        endTurnAndTakeNewTile.isEnabled = false
    }
    
    @IBAction func placeTile() {
        if game.isTileOkToPlace {
            game.placeTileOnMap()
//            picture?.makeRedSignal(shadowColor: .clear)
//            picture?.placed()
            endTurnAndTakeNewTile.isEnabled = true
        }
    }
    
    @IBAction func moveTileUP() {
        game.currentTile?.moveUp()
//        picture!.moveUp()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileRight() {
        game.currentTile?.moveRight()
//        picture!.moveRight()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileDown() {
        game.currentTile?.moveDown()
//        picture!.moveDown()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileLeft() {
        game.currentTile?.moveLeft()
//        picture!.moveLeft()
        chekForPlaceAndSignal()
    }
    
    @IBAction func rotateTileClockwise() {
        game.currentTile?.rotateClockwise()
//        picture!.rotateClockwise()
        chekForPlaceAndSignal()
    }
    
    @IBAction func rotateTileAnticlockwise() {
        game.currentTile?.rotateСounterclockwise()
//        picture!.rotateAnticlockwise()
        chekForPlaceAndSignal()
    }
    
    func chekForPlaceAndSignal() {
        if game.isTileOkToPlace {
//            picture?.makeRedSignal(shadowColor: .systemBlue)
        } else {
//            picture?.makeRedSignal(shadowColor: .systemRed)
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
            view.addSubview(picture)
        }
        
        guard let currentTile = game.currentTile else {
            return
        }
        
        let picture = TilePicture(tilePictureName: currentTile.tilePictureName, view: view)
        picture.possitionInX(coordinatesOfTilesX: currentTile.coordinates.0)
        picture.possitionInY(coordinateOfTilesY: currentTile.coordinates.1)
        picture.imageRotationPossition(rotationCalculation: currentTile.rotationCalculation)
        view.addSubview(picture)
    }
}
