//
//  LoadMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.06.2023.
//

import UIKit

class LoadMenuViewController: UIViewController {

    @IBOutlet weak var gamesForLoadingView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        for gameAndDate in GameCoreDAO.getAllGamesAndDates() {
            let savedGameLabel = GameLabelInLoadMenuView(
                players: gameAndDate.0.players, date: gameAndDate.1)
            savedGameLabel.deleteButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
            gamesForLoadingView.addArrangedSubview(savedGameLabel)
        }
    }
    
    @objc func pressed(date: Date) {
        GameCoreDAO.delete(date: date)
    }
}
