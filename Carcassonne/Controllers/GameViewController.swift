//
//  ViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.04.2023.
//

import UIKit

enum TargetControl {
    case tile
    case meeple
}

class GameViewController: UIViewController {

    var game = GameCore(tilesStack: TileStorage.tilePool, firstTile: TileStorage.startTile) {
        didSet { 
            game.updateMovementDirectionsAvailability(target: target)
            changeButtonAvailability(gameState: game.gameState)
            let rendering = GameViewRender(
                game: self.game,
                view: gameMapView,
                superView: self.view,
                playersList: playerList
            )
        }
    }
    
    var target = TargetControl.tile

    @IBOutlet var gameMapView: UIScrollView!
    @IBOutlet var playerList: UIStackView!
    @IBOutlet var rightPannel: UIView!
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        rightPannel.backgroundColor = gameMapView.backgroundColor?.withAlphaComponent(0.5)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "\(InGameMenuController.self)") {
            if let InGameMenuController = segue.destination as? InGameMenuController {
                InGameMenuController.game = game
            }
        }
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
        moveUpButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMoveTileOrMeepleIsPossible(givenDirection: .up(true))
        rotateClockwiseButton?.isEnabled = game.gameState.isRotateEnabled()
        moveLeftButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMoveTileOrMeepleIsPossible(givenDirection: .left(true))
        moveDownButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMoveTileOrMeepleIsPossible(givenDirection: .down(true))
        moveRightButton?.isEnabled = game.gameState.isMovingEnabled() && game.isMoveTileOrMeepleIsPossible(givenDirection: .right(true))
        endTurnAndTakeNewTileButton?.isEnabled = game.gameState.isNextTurnEnabled()
        placeTileButton?.isEnabled = game.gameState.isPlaceEnabled()
        takeTileBackButton?.isEnabled = game.gameState.isPickupEnabled()
        changeControl?.isEnabled = game.gameState.isMeepleTileControlEnabled()
    }
    
    @IBAction func takeNewTile() {
        switch target {
        case .tile:
            game.endOfTurnTakeNewTile()
        case .meeple:
            target = .tile
            game.endOfTurnTakeNewTile()
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
#warning("why return")
            return
        }
    }
    
    @IBAction func moveTileUP() {
        moveTileOrMeepleIfPossible(givenDirection: .up(true))
    }
    
    @IBAction func moveTileRight() {
        moveTileOrMeepleIfPossible(givenDirection: .right(true))
    }
    
    @IBAction func moveTileDown() {
        moveTileOrMeepleIfPossible(givenDirection: .down(true))
    }
    
    @IBAction func moveTileLeft() {
        moveTileOrMeepleIfPossible(givenDirection: .left(true))
    }
    
    func moveTileOrMeepleIfPossible(givenDirection: MovingDirection) {
        for direction in game.movementDirectionsAvailability {
            if direction == givenDirection {
                switch direction {
                case .up:
                    moveTileOrMeeple(inDirection: givenDirection)
                case .right:
                    moveTileOrMeeple(inDirection: givenDirection)
                case .down:
                    moveTileOrMeeple(inDirection: givenDirection)
                case .left:
                    moveTileOrMeeple(inDirection: givenDirection)
                }
            }
        }
    }
    
    func moveTileOrMeeple(inDirection: MovingDirection) {
        switch target {
        case .tile:
            inDirection.moveCoordinatesInDirection(coordinates: &game.currentTile!.coordinates)
        case .meeple:
            inDirection.moveCoordinatesInDirection(coordinates: &game.unsafeLastTile.meeple!.coordinates)
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
}
