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

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        view.backgroundColor = .systemGray6
        let menuView = StartMenuView { [weak self] button in
            self?.actionsForButtons(button: button)
        }
        menuView.backgroundColor = .white
        view.addSubview(menuView)

        menuView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            menuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

//            menuView.topAnchor.constraint(equalTo: view.topAnchor),
//            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private extension StartViewController {

    func actionsForButtons(button: StartMenuButtonAction) {
        switch button {
        case .continueButton:
            break
        case .startNewGameButton:
            break
        case .loadGameButton:
            let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
            loadMenuViewController.modalPresentationStyle = .formSheet
            self.present(loadMenuViewController, animated: true)
        case .settingsButton:
            break
        }
    }
}
