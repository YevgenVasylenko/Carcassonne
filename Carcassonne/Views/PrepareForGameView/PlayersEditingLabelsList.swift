//
//  PlayersEditingLabelsList.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class PlayersEditingLabelsList: UIStackView {

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

private extension PlayersEditingLabelsList {

    func configure(
        players: [Player],
        colors: [PlayerColor],
        changeName: @escaping (Player, String) -> (),
        changeColor: @escaping (Player, PlayerColor) -> (),
        presentPopover: @escaping (ColorsChoosingPopup) -> ()
    ) {

        self.distribution = .equalCentering
        self.alignment = .center

        let leftSpacer = UIView()
        addArrangedSubview(leftSpacer)

        for playerNumber in players.indices {
            let playerEditLabel = NewPlayerEditingLabel(
                playerNumber: playerNumber,
                player: players[playerNumber]) { name in
                    changeName(players[playerNumber], name)
                }

            addArrangedSubview(playerEditLabel)
            playerEditLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                playerEditLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/10),
            ])

            playerEditLabel.meepleColorChoiceButton.addAction(UIAction(handler: { _ in

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

        let rightSpacer = UIView()
        addArrangedSubview(rightSpacer)
    }
}
