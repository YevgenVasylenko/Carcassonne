//
//  StartMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {

        let backgroundView = UIImageView(image: UIImage(named: "startMenuBackgroundView"))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.contentMode = .scaleToFill

        let menuView = StartMenuView { [weak self] button in
            self?.actionsForButtons(button: button)
        }

        view.addSubview(backgroundView)
        backgroundView.addSubview(menuView)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            menuView.topAnchor.constraint(equalTo: view.topAnchor, constant: -view.frame.height * 0.275),
            menuView.heightAnchor.constraint(equalTo: view.heightAnchor),
            menuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

private extension StartViewController {

    func actionsForButtons(button: StartMenuButton) {
        switch button {
        case .continueButton:
            break
        case .startNewGameButton:
            let startNewGameViewController: StartNewGameViewController =  UIStoryboard.makeViewController()
            let navigationController = self.presentingViewController as? UINavigationController
            navigationController?.setViewControllers([self, startNewGameViewController], animated: true)
        case .loadGameButton:
            let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
            loadMenuViewController.modalPresentationStyle = .formSheet
            self.present(loadMenuViewController, animated: true)
        case .settingsButton:
            break
        }
    }
}
