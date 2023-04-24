//
//  ViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {

    var game = LandScape()
    var picture: TilePicture?
    var mapView = UIScrollView()
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var endTurnAndTakeNewTile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        game = LandScape(tilesStack: TilesToPlay, tilesOnMap: [startTile], currentTile: startTile)
        mapView = UIScrollView(frame: self.view.bounds)
        mapView.backgroundColor = .white
        mapView.contentSize = CGSize(width: 2000, height: 2000)
        self.view.addSubview(mapView)
        picture = TilePicture(tilePictureName:
                                game.currentTile!.tilePictureName, view: mapView)
        mapView.addSubview(picture!)
        self.view.bringSubviewToFront(buttonsView)
    }
    
    
    @IBAction func takeNewTile() {
        game.tileFromStack()
        picture = TilePicture(tilePictureName: game.currentTile!.tilePictureName, view: mapView)
        mapView.addSubview(picture!)
        picture?.makeRedSignal(shadowColor: .systemRed)
        endTurnAndTakeNewTile.isEnabled = false
    }
    
    @IBAction func placeTile() {
        if game.isTileOkToPlace {
            game.placeTileOnMap()
            picture?.makeRedSignal(shadowColor: .clear)
            picture?.placed()
            endTurnAndTakeNewTile.isEnabled = true
        }
    }
    
    @IBAction func moveTileUP() {
        game.currentTile?.moveUp()
        picture!.moveUp()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileRight() {
        game.currentTile?.moveRight()
        picture!.moveRight()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileDown() {
        game.currentTile?.moveDown()
        picture!.moveDown()
        chekForPlaceAndSignal()
    }
    
    @IBAction func moveTileLeft() {
        game.currentTile?.moveLeft()
        picture!.moveLeft()
        chekForPlaceAndSignal()
    }
    
    @IBAction func rotateTileClockwise() {
        game.currentTile?.rotateClockwise()
        picture!.rotateClockwise()
        chekForPlaceAndSignal()
    }
    
    @IBAction func rotateTileAnticlockwise() {
        game.currentTile?.rotateAnticlockwise()
        picture!.rotateAnticlockwise()
        chekForPlaceAndSignal()
    }
    
    func chekForPlaceAndSignal() {
        if game.isTileOkToPlace {
            picture?.makeRedSignal(shadowColor: .systemBlue)
        } else {
            picture?.makeRedSignal(shadowColor: .systemRed)
        }
    }
}

