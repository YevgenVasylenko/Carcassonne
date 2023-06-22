//
//  InGameMenuController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 18.06.2023.
//

import UIKit

class InGameMenuController: UIViewController {
    var game: GameCore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveGameButton() {
        guard let game = game else { return }
        GameCoreDAO.saveGame(game: game)
    }
}
