//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.03.2024.
//

import UIKit

class GameLabelForLoadingMenuView: UIStackView {
    private let playersLabel = UIStackView()
    private let dateAndDelete = UIStackView()
    private let dateLabel = UILabel()
    let deleteButton = UIButton()

    init(players: [Player], date: Date) {
        super .init(frame: .zero)
        configure(players: players, date: date)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(players: [Player], date: Date) {
        axis = .horizontal

        addArrangedSubview(playersLabel)
        addArrangedSubview(dateAndDelete)

        dateAndDelete.distribution = .equalSpacing

        playersLabel.axis = .vertical
        dateAndDelete.axis = .horizontal

        dateAndDelete.addArrangedSubview(dateLabel)
        dateAndDelete.addArrangedSubview(deleteButton)

        dateLabel.text = "\(date.formatted(date: .numeric, time: .omitted))"

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)

        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndDelete.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateAndDelete.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            dateAndDelete.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        for player in players {
            let playerNameAndColor = UIStackView()
            let colorPlayerIndicator = UIImageView()
            let playerName = UILabel()
            let score = UILabel()

            playerNameAndColor.addArrangedSubview(colorPlayerIndicator)
            colorPlayerIndicator.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            playerNameAndColor.addArrangedSubview(playerName)
            playerName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            playerNameAndColor.addArrangedSubview(score)
            
            playersLabel.addArrangedSubview(playerNameAndColor)

            playerName.text = "\(player.name)"
            score.text = "\(player.score)"
            colorPlayerIndicator.image = UIImage(systemName: "circle.fill")
            colorPlayerIndicator.tintColor = player.color.getColor()
            playerNameAndColor.axis = .horizontal

            colorPlayerIndicator.translatesAutoresizingMaskIntoConstraints = false
            playerName.translatesAutoresizingMaskIntoConstraints = false
            score.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                colorPlayerIndicator.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor),
                playerName.leadingAnchor.constraint(equalTo: colorPlayerIndicator.trailingAnchor),
                score.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/8),
                score.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor)
            ])
        }
    }
}
