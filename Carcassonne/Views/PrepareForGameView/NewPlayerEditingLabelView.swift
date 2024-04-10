//
//  NewPlayerEditingLabelView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class NewPlayerEditingLabelView: UIStackView {

    private let playerWithNumber = UILabel()
    private let playerName = UITextField()
    let meepleColorChoiceButton = UIButton()

    init(
        playerNumber: Int,
        player: Player,
        completion: @escaping (String) -> Void
    ) {
        super.init(frame: .zero)
        configure(
            playerNumber: playerNumber,
            player: player,
            completion: completion
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewPlayerEditingLabelView {

    func configure(
        playerNumber: Int,
        player: Player,
        completion: @escaping (String) -> Void
    ) {
        axis = .vertical

        addArrangedSubview(playerWithNumber)
        addArrangedSubview(playerName)
        addArrangedSubview(meepleColorChoiceButton)

        playerWithNumber.text = "Player \(playerNumber)"
        playerWithNumber.textAlignment = .center
        playerWithNumber.adjustsFontSizeToFitWidth = true

        playerName.placeholder = "Player name"
        playerName.text = player.name
        playerName.addAction(UIAction(handler: { [weak self] _ in
            completion(self?.playerName.text ?? "")
        }), for: .editingDidEnd)

        meepleColorChoiceButton.setImage(UIImage(named: "meeple")?.withTintColor(player.color.getColor()), for: .normal)
        meepleColorChoiceButton.imageView?.contentMode = .scaleAspectFit

        playerWithNumber.translatesAutoresizingMaskIntoConstraints = false
        playerName.translatesAutoresizingMaskIntoConstraints = false
        meepleColorChoiceButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playerWithNumber.topAnchor.constraint(equalTo: topAnchor),
            playerName.topAnchor.constraint(equalTo: playerWithNumber.bottomAnchor),
            playerName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            meepleColorChoiceButton.topAnchor.constraint(equalTo: playerName.bottomAnchor),
            meepleColorChoiceButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            meepleColorChoiceButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
