//
//  PlayersEditingLabelsListView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class PlayersEditingLabelsListView: UIStackView {

    let addNewPlayerButton = UIButton()

    init(
        players: [Player],
        colors: [PlayerColor],
        changeName: @escaping (Player, String) -> (),
        changeColor: @escaping (Player, PlayerColor) -> (),
        presentPopover: @escaping (ColorsChoosingPopup) -> ()
    ) {
        super.init(frame: .zero)
        configure(
            players: players,
            colors: colors,
            changeName: changeName,
            changeColor: changeColor,
            presentPopover: presentPopover
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlayersEditingLabelsListView {

    func configure(
        players: [Player],
        colors: [PlayerColor],
        changeName: @escaping (Player, String) -> (),
        changeColor: @escaping (Player, PlayerColor) -> (),
        presentPopover: @escaping (ColorsChoosingPopup) -> ()
    ) {

        alignment = .center
        spacing = UIScreen.main.bounds.width / 12

        for playerNumber in players.indices {
            let playerEditLabel = NewPlayerEditingLabelView(
                player: players[playerNumber]) { name in
                    changeName(players[playerNumber], name)
                }

            addArrangedSubview(playerEditLabel)
            playerEditLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                playerEditLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 10)
            ])
            playerEditLabel.meepleColorChoiceButton.addAction(UIAction(handler: { [weak self, weak playerEditLabel] _ in

                guard let self, let playerEditLabel else { return }

                let popoverViewController = ColorsChoosingPopup(
                    availablePlayerColors: colors) { color in
                    changeColor(players[playerNumber], color)
                    }
                popoverViewController.modalPresentationStyle = .popover
                popoverViewController.preferredContentSize = CGSizeMake((self.superview?.frame.width ?? 1) / 5, (playerEditLabel.frame.height / 4) * CGFloat(colors.count))

                let popover = popoverViewController.popoverPresentationController
                popover?.permittedArrowDirections = .up
                popover?.sourceView = playerEditLabel
                presentPopover(popoverViewController)
            }), for: .touchUpInside)
        }
        addNewPlayerButton(players: players)
    }

    func addNewPlayerButton(players: [Player]) {
        if players.count < 5 {
            addNewPlayerButton.setImage(UIImage(systemName: "plus.rectangle.portrait"), for: .normal)
            addArrangedSubview(addNewPlayerButton)
            addNewPlayerButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                addNewPlayerButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/10),
            ])
        }
    }
}

