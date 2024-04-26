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
        menuAppearanceAnimation()
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.navigationController?.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        menuDisappearAnimation()
        super.viewWillDisappear(animated)
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
            delay: 1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 5,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.menuView.transform = CGAffineTransform.identity
            })
    }

    func menuDisappearAnimation() {
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self else { return }
            self.menuView.transform = .init(translationX: 0, y: -self.view.frame.height)
        }
    }

    func actionsForButtons(button: StartMenuAction) {
        switch button {
        case .continueButton:
            loadLastGame()
        case .startNewGameButton:
            self.navigationController?.pushViewController(StartNewGameViewController(), animated: true)
        case .loadGameButton:
            let loadMenuViewController = LoadingViewController(collectionViewLayout: UICollectionViewFlowLayout())
#warning("memory leak. need to update main menu buttons if no games for loading")
//            loadMenuViewController.actionOnDisappear = { [weak self] in
//                self?.configure()
//            }
            loadMenuViewController.modalPresentationStyle = .custom
            loadMenuViewController.transitioningDelegate = loadMenuViewController
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
}

extension MainMenuViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NavigationTransitionAnimator(presentingType: operation)
    }
}
