//
//  StartMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

class StartViewController: UIViewController {

    let menuView = StartMenuView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuAppearanceAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {

        let backgroundView = UIImageView(image: UIImage(named: "startMenuBackgroundView"))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.contentMode = .scaleToFill

        menuView.buttonAction = { [weak self] button in
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

    func menuAppearanceAnimation() {
        menuView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -view.frame.height)
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseIn) { [weak self] in
            self?.menuView.transform = CGAffineTransform.identity
        }
    }

    func actionsForButtons(button: StartMenuAction) {
        switch button {
        case .continueButton:
            break
        case .startNewGameButton:
            self.navigationController?.pushViewController(StartNewGameViewController(), animated: true)
        case .loadGameButton:
            let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
            loadMenuViewController.modalPresentationStyle = .formSheet
            self.present(loadMenuViewController, animated: true)
        case .settingsButton:
            break
        }
    }
}
