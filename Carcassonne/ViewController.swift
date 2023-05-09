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

    var game = GameCore() {
        didSet {
            let rendering = Rendering(game: self.game, view: mapView)
            rendering.render()
        }
    }
    var mapView = UIScrollView()
    var target = TargetControl.tile
    
    @IBOutlet var buttonsView: UIView!

    @IBOutlet weak var rotateTileCounterclockwise: UIButton!
    @IBOutlet var endTurnAndTakeNewTileButton: UIButton!
    @IBOutlet var placeTileButton: UIButton!
    @IBOutlet var takeTileBackButton: UIButton!
    @IBOutlet var changeControl: UIButton!
    
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
        takeTileBackButton.isEnabled = false
        changeControl.setImage(UIImage(systemName: "figure.mind.and.body" ), for: .normal)
    }
    
    
    @IBAction func changeControlButton() {
        switch target {
        case .tile:
            game.placeMeeple()
            target = .meeple
            changeControl.setImage(UIImage(systemName: "square"), for: .normal)
        case .meeple:
            target = .tile
            changeControl.setImage(UIImage(systemName: "figure.mind.and.body"), for: .normal)
        }
    }
    
    func changeButtonAvailability(gameState: GameState) {
        switch gameState {
            
        case .gameStart:
            break
        case .currentTileOperrate(let isCanBePlace):
            <#code#>
        case .currentTileNotOperrrate(let meepleOperrate):
            switch meepleOperrate {
            case .meepleOperrate(isCanBePlace: let isCanBePlace):
                <#code#>
            case .meepleNotOperrate:
                <#code#>
            }
        }
    }
    
    func makeAllButtonAvailable() {
        
    }
    
    @IBAction func takeNewTile() {
        game.tileFromStack()
        endTurnAndTakeNewTileButton.isEnabled = false
        takeTileBackButton.isEnabled = false
    }
    
    @IBAction func placeTile() {
        switch target {
        case .tile:
            if game.isTileCanBePlace {
                game.placeTileOnMap()
                endTurnAndTakeNewTileButton.isEnabled = true
                takeTileBackButton.isEnabled = true
            }
        case .meeple:
            target = .tile
        }
    }
    
    @IBAction func takeTileBack() {
        switch target {
        case .tile:
            game.takeTileBack()
            takeTileBackButton.isEnabled = false
            endTurnAndTakeNewTileButton.isEnabled = false
        case .meeple:
            game.currentTile?.removeMeeple()
        }
    }
    
    @IBAction func moveTileUP() {
        switch target {
        case .tile:
            game.currentTile?.moveUp()
        case .meeple:
            game.tilesOnMap[game.tilesOnMap.count-1].meeple.moveMeepleUp()
        }
    }
    
    @IBAction func moveTileRight() {
        switch target {
        case .tile:
            game.currentTile?.moveRight()
        case .meeple:
            game.tilesOnMap[game.tilesOnMap.count-1].meeple.moveMeepleRight()
        }
    }
    
    @IBAction func moveTileDown() {
        switch target {
        case .tile:
            game.currentTile?.moveDown()
        case .meeple:
            game.tilesOnMap[game.tilesOnMap.count-1].meeple.moveMeepleDown()
        }
    }
    
    @IBAction func moveTileLeft() {
        switch target {
        case .tile:
            game.currentTile?.moveLeft()
        case .meeple:
            game.tilesOnMap[game.tilesOnMap.count-1].meeple.moveMeepleLeft()
        }
    }
    
    @IBAction func rotateTileClockwise() {
        game.currentTile?.rotateClockwise()
    }
    
    @IBAction func rotateTileAnticlockwise() {
        game.currentTile?.rotateСounterclockwise()
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
            
            let picture = TilePicture(tile: tile, view: view)
        }
        
        guard let tile = game.currentTile else { return }
        
        let picture = TilePicture(tile: tile, view: view)
        picture.makeShadow(isTileCanBePlace: game.isTileCanBePlace)
    }
}
