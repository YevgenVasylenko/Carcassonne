//
//  ViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import UIKit

class GameViewController: UIViewController {
    
    enum TargetControl {
        case tile
        case meeple
    }
    
    var game = GameCore(tilesStack: TileStorage.tilePool, firstTile: TileStorage.startTile) {
        didSet {
            changeButtonAvailability(gameState: game.gameState)
            let rendering = GameViewRender(game: self.game, view: gameMapView, superView: self.view)
            rendering.render()
        }
    }
    
    var target = TargetControl.tile
    
    @IBOutlet var gameMapView: UIScrollView!
    @IBOutlet var playerList: UIStackView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addPlayersLabels()
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
        rotateTileCounterclockwiseButton?.isEnabled = game.gameState.isRotateEnabled()
        moveUpButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMovementAvailable({$0.up()})
        rotateClockwiseButton?.isEnabled = game.gameState.isRotateEnabled()
        moveLeftButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMovementAvailable({$0.left()})
        moveDownButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMovementAvailable({$0.down()})
        moveRightButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMovementAvailable({$0.right()})
        endTurnAndTakeNewTileButton?.isEnabled = game.gameState.isNextTurnEnabled()
        placeTileButton?.isEnabled = game.gameState.isPlaceEnabled()
        takeTileBackButton?.isEnabled = game.gameState.isPickupEnabled()
        changeControl?.isEnabled = game.gameState.isMeepleTileControlEnabled()
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
            if game.isMovementAvailable({ $0.up() }) {
                game.currentTile?.coordinates.moveUp()
            }
        case .meeple:
            guard let meeple = game.unsafeLastTile.meeple else { return }
            if meeple.isMovementAvailable({ $0.up() }) {
                game.unsafeLastTile.meeple?.coordinates.moveUp()
            }
        }
    }
    
    @IBAction func moveTileRight() {
        switch target {
        case .tile:
            if game.isMovementAvailable({ $0.right() }) {
                game.currentTile?.coordinates.moveRight()
            }
        case .meeple:
            guard let meeple = game.unsafeLastTile.meeple else { return }
            if meeple.isMovementAvailable({ $0.right() }) {
                game.unsafeLastTile.meeple?.coordinates.moveRight()
            }
        }
    }
    
    @IBAction func moveTileDown() {
        switch target {
        case .tile:
            if game.isMovementAvailable({ $0.down() }) {
                game.currentTile?.coordinates.moveDown()
            }
        case .meeple:
            guard let meeple = game.unsafeLastTile.meeple else { return }
            if meeple.isMovementAvailable({ $0.down() }) {
                game.unsafeLastTile.meeple?.coordinates.moveDown()
            }
        }
    }
    
    @IBAction func moveTileLeft() {
        switch target {
        case .tile:
            if game.isMovementAvailable({ $0.left() }) {
                game.currentTile?.coordinates.moveLeft()
            }
        case .meeple:
            guard let meeple = game.unsafeLastTile.meeple else { return }
            if meeple.isMovementAvailable({ $0.left() }) {
                game.unsafeLastTile.meeple?.coordinates.moveLeft()
            }
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
            changeControl?.setImage(UIImage(systemName: "figure.mind.and.body"), for: .normal)
        case .meeple:
            changeControl?.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    func addPlayersLabels() {
        for player in game.players {
            playerList.addArrangedSubview(
                PlayerLabelGameView(player: player)
            )
        }
    }
}
