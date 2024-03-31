//
//  StartMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

class StartMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LoadGameButton(_ sender: Any) {
        let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
        loadMenuViewController.modalPresentationStyle = .formSheet
        self.present(loadMenuViewController, animated: true)
    }
}
