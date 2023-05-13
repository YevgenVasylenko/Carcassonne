//
//  ViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    enum TargetControl {
        case tile
        case meeple
    }

    var game = GameCore(tilesStack: TileStorage.tilePool, firstTile: TileStorage.startTile) {
        didSet {
            changeButtonAvailability(gameState: game.gameState)
            let rendering = Rendering(game: self.game, view: mapView)
            rendering.render()
        }
    }
    var mapView = UIScrollView()
    var target = TargetControl.tile
    
    @IBOutlet var buttonsView: UIView!

    @IBOutlet weak var rotateTileCounterclockwiseButton: UIButton!
    @IBOutlet weak var moveUpButton: UIButton!
    @IBOutlet weak var rotateClockwiseButton: UIButton!
    @IBOutlet weak var moveLeftButton: UIButton!
    @IBOutlet weak var moveDownButton: UIButton!
    @IBOutlet weak var moveRightButton: UIButton!
    @IBOutlet var endTurnAndTakeNewTileButton: UIButton!
    @IBOutlet var placeTileButton: UIButton!
    @IBOutlet var takeTileBackButton: UIButton!
    @IBOutlet var changeControl: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = UIScrollView(frame: self.view.bounds)
        mapView.backgroundColor = .white
        mapView.contentSize = CGSize(width: 1000, height: 1000)
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(buttonsView)
    }
    
    
    @IBAction func changeControlButton() {
        switch target {
        case .tile:
            game.createMeeple()
            target = .meeple
            changeChangeControlButtonImage()
        case .meeple:
            target = .tile
            game.removeMeeple()
            changeChangeControlButtonImage()
        }
    }
    
    func changeButtonAvailability(gameState: GameState) {
        rotateTileCounterclockwiseButton.isEnabled = game.gameState.isRotateEnabled()
        moveUpButton.isEnabled = game.gameState.isMovingEnabled()
        rotateClockwiseButton.isEnabled = game.gameState.isRotateEnabled()
        moveLeftButton.isEnabled = game.gameState.isMovingEnabled()
        moveDownButton.isEnabled = game.gameState.isMovingEnabled()
        moveRightButton.isEnabled = game.gameState.isMovingEnabled()
        endTurnAndTakeNewTileButton.isEnabled = game.gameState.isNextTurnEnabled()
        placeTileButton.isEnabled = game.gameState.isPlaceEnabled()
        takeTileBackButton.isEnabled = game.gameState.isPickupEnabled()
        changeControl.isEnabled = game.gameState.isMeepleTileControlEnabled()
    }
    
    @IBAction func takeNewTile() {
        switch target {
        case .tile:
            game.tileFromStack()
        case .meeple:
            game.tileFromStack()
            target = .tile
            changeChangeControlButtonImage()
        }
    }
    
    @IBAction func placeTile() {
        switch target {
        case .tile:
            if game.isTileCanBePlace {
                game.placeTileOnMap()
            }
        case .meeple:
            game.placeMeeple()
        }
    }
    
    @IBAction func takeTileBack() {
        switch target {
        case .tile:
            game.takeTileBack()
        case .meeple:
            game.pickUpMeeple()
            return
        }
    }
    
    @IBAction func moveTileUP() {
        switch target {
        case .tile:
            game.currentTile?.moveUp()
        case .meeple:
            game.unsafeLastTile.meeple?.moveMeepleUp()
        }
    }
    
    @IBAction func moveTileRight() {
        switch target {
        case .tile:
            game.currentTile?.moveRight()
        case .meeple:
            game.unsafeLastTile.meeple?.moveMeepleRight()
        }
    }
    
    @IBAction func moveTileDown() {
        switch target {
        case .tile:
            game.currentTile?.moveDown()
        case .meeple:
            game.unsafeLastTile.meeple?.moveMeepleDown()
        }
    }
    
    @IBAction func moveTileLeft() {
        switch target {
        case .tile:
            game.currentTile?.moveLeft()
        case .meeple:
            game.unsafeLastTile.meeple?.moveMeepleLeft()
        }
    }
    
    @IBAction func rotateTileClockwise() {
        game.currentTile?.rotateClockwise()
    }
    
    @IBAction func rotateTileCounterclockwise() {
        game.currentTile?.rotateCounterclockwise()
    }
    
    func changeChangeControlButtonImage() {
        switch target {
        case .tile:
            changeControl.setImage(UIImage(systemName: "figure.mind.and.body"), for: .normal)
        case .meeple:
            changeControl.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
}

struct Rendering {
    
    let game: GameCore
    let view: UIView

    init(game: GameCore, view: UIView) {
        self.game = game
        self.view = view
    }
    
    func render() {
        
        for picture in view.subviews {
            picture.removeFromSuperview()
        }
        
        for tile in game.tilesOnMap {
            
            let picture = TilePicture(tile: tile, view: view)
        }
        
        guard let tile = game.currentTile else { return }
        
        let picture = TilePicture(tile: tile, view: view)
        picture.makeShadow(isTileCanBePlace: game.isTileCanBePlace)
    }
}
