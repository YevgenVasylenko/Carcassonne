//
//  MainMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

final class MainMenuViewController: UIViewController {

    private var menuView = MainMenuView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuAppearanceAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuDisappearAnimation()
    }

    func configure() {

        let backgroundView = UIImageView(image: UIImage(named: "startMenuBackgroundView"))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.contentMode = .scaleToFill

        menuView.buttonAction = { [weak self] button in
            self?.actionsForButtons(button: button)
        }

        view.addSubview(backgroundView)

        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        menuView.configure()
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

        menuView.setNeedsDisplay()
    }
}

private extension MainMenuViewController {

    func menuAppearanceAnimation() {
        menuView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -view.frame.height)
        UIView.animate(
            withDuration: 1.5,
            delay: 0.5,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 5,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.menuView.transform = CGAffineTransform.identity
            })
    }

    func menuDisappearAnimation() {
        UIView.animate(withDuration: 1.5) { [weak self] in
            guard let self else { return }
            self.menuView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.view.frame.height)
        }
    }

    func actionsForButtons(button: StartMenuAction) {
        switch button {
        case .continueButton:
            loadLastGame()
        case .startNewGameButton:
            self.navigationController?.view.layer.add(transitionForNewGameScreen(), forKey: kCATransition)
            self.navigationController?.pushViewController(StartNewGameViewController(), animated: true)
        case .loadGameButton:
            let loadMenuViewController = LoadMenuViewController(collectionViewLayout: UICollectionViewFlowLayout())
            loadMenuViewController.actionOnDisappear = { [weak self] in
                self?.configure()
            }
            loadMenuViewController.modalPresentationStyle = .formSheet
            self.present(loadMenuViewController, animated: true)
        case .settingsButton:
            break
        }
    }

    func loadLastGame() {
        if let lastGame = GameCoreDAO.getLastGame() {
            let gameViewController: GameViewController =  UIStoryboard.makeViewController()
            gameViewController.loadViewIfNeeded()
            gameViewController.game = lastGame

            self.dismiss(animated: true) {
                let startMenuViewController = MainMenuViewController()
                self.navigationController?.setViewControllers([startMenuViewController, gameViewController], animated: true)
            }
        }
    }

    func transitionForNewGameScreen() -> CATransition {
        let transition = CATransition()
        transition.beginTime = CACurrentMediaTime() + 2
        transition.duration = 0.5
        transition.fillMode = .both
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        return transition
    }
}
