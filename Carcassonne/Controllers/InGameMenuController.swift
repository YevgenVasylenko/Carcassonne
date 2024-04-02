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
        guard let game = game else {
            return
        }
        GameCoreDAO.saveOrUpdateGame(game: game)
    }

    @IBAction func loadGameButton() {
        let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
        loadMenuViewController.modalPresentationStyle = .formSheet
        let navigationController = self.presentingViewController as? UINavigationController
        
        self.dismiss(animated: true) {
            navigationController?.present(loadMenuViewController, animated: true)
        }
    }

    @IBAction func exitToMainMenuButton() {
        saveGameButton()
        
        let navigationController = self.presentingViewController as? UINavigationController

        self.dismiss(animated: true) {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
