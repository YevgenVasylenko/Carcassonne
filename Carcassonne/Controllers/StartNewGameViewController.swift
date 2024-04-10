//
//  StartNewGameViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

final class StartNewGameViewController: UIViewController {

    private let maxNumberOfPlayers = 5
    private var players: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fillUpPlayersList()
        configure()
    }
}

private extension StartNewGameViewController {

    func configure() {
        view.backgroundColor = .white

        for picture in view.subviews {
            picture.removeFromSuperview()
        }

        let startCustomButton = StartButton(playersCount: readyPlayers().count) { [weak self] in
            guard let self = self else { return }
            let gameViewController: GameViewController =  UIStoryboard.makeViewController()
            gameViewController.loadViewIfNeeded()
            gameViewController.game.players = self.readyPlayers()
            self.dismiss(animated: true) {
                self.navigationController?.pushViewController(gameViewController, animated: true)
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
                self?.present(popover, animated: true)
            })

        view.addSubview(startCustomButton)
        view.addSubview(playersList)

        startCustomButton.translatesAutoresizingMaskIntoConstraints = false
        playersList.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            startCustomButton.bottomAnchor.constraint(equalTo: playersList.topAnchor),
            startCustomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            playersList.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/6),
            playersList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playersList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playersList.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func fillUpPlayersList() {
        for _ in 1...maxNumberOfPlayers {
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
}
