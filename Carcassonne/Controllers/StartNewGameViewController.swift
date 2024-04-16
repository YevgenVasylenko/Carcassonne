//
//  StartNewGameViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

final class StartNewGameViewController: UIViewController {

    private let minNumberOfPlayers = 2
    private var players: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fillUpPlayersList()
        configure()
        initializeHideKeyboard()
    }
}

private extension StartNewGameViewController {

    func configure() {
        view.backgroundColor = .white

        for view in view.subviews {
            view.removeFromSuperview()
        }

        let startButton = StartButton()
        startButton.startGame = { [weak self, weak startButton] in
            guard let self else { return }

            let players = self.readyPlayers()
            if players.count < 2 {
                startButton?.wiggle()
                return
            }

            let gameViewController: GameViewController =  UIStoryboard.makeViewController()
            gameViewController.loadViewIfNeeded()
            gameViewController.game.players = players
            self.dismiss(animated: true) {
                let startMenuViewController = MainMenuViewController()
                self.navigationController?.setViewControllers([startMenuViewController, gameViewController], animated: true)
            }
        }

        let playersList = PlayersEditingLabelsListView(
            players: players,
            colors: availableColors(),
            changeName: { [weak self] player, playerName in
                self?.changeNameForPlayer(id: player.id, name: playerName)
            },
            changeColor: { [weak self] player, playerColor in
                self?.changeColorForPlayer(id: player.id, color: playerColor)
            },
            presentPopover: {  [weak self] popover in
                self?.view.endEditing(true)
                self?.present(popover, animated: true)
            })

        playersList.addNewPlayerButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.players.append(Player())
            self.configure()
        }), for: .touchUpInside)

        view.addSubview(startButton)
        view.addSubview(playersList)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        playersList.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            playersList.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6),
            playersList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playersList.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }

    func fillUpPlayersList() {
        for _ in 1...minNumberOfPlayers {
            players.append(Player())
        }
    }

    func changeColorForPlayer(id: UUID, color: PlayerColor) {
        for player in players.indices {
            if players[player].id == id {
                players[player].color = color
            }
        }
        configure()
    }

    func changeNameForPlayer(id: UUID, name: String) {
        for player in players.indices {
            if players[player].id == id {
                players[player].name = name
            }
        }
    }

    func availableColors() -> [PlayerColor] {
        let colors = PlayerColor.allCases

        return colors.filter { color in
            for player in players {
                if player.color == color && player.color != .none {
                    return false
                }
            }
            return true
        }
    }

    func readyPlayers() -> [Player] {
        return self.players.filter({ player in
            player.isReadyForStartGame()
        })
    }

    func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard)
        )
        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}
