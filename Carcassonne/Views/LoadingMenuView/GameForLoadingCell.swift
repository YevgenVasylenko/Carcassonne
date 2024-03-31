//
//  GameForLoadingCell.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.03.2024.
//

import UIKit

final class GameForLoadingCell: UICollectionViewCell {

    private let playersLabel = UIStackView()
    private let dateAndDelete = UIStackView()
    private let dateLabel = UILabel()
    private let deleteButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(data: (GameCore, Date), deleteAction: @escaping () -> ()) {
        backgroundColor = .white

        playersLabel.subviews.forEach { $0.removeFromSuperview() }
        playersLabel.spacing = 4

        dateLabel.text = "\(data.1.formatted(date: .numeric, time: .omitted))"

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addAction(UIAction(handler: { _ in
            deleteAction()
        }), for: .touchUpInside)

        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndDelete.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateAndDelete.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            dateAndDelete.leadingAnchor.constraint(equalTo: playersLabel.trailingAnchor),
            dateAndDelete.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            dateAndDelete.centerYAnchor.constraint(equalTo: centerYAnchor),
            playersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        for player in data.0.players {
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
            playerNameAndColor.setCustomSpacing(4, after: colorPlayerIndicator)

            colorPlayerIndicator.translatesAutoresizingMaskIntoConstraints = false
            playerName.translatesAutoresizingMaskIntoConstraints = false
            score.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                colorPlayerIndicator.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor),
                score.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/8),
                score.leadingAnchor.constraint(equalTo: playerName.trailingAnchor),
                score.trailingAnchor.constraint(equalTo: playersLabel.trailingAnchor)
            ])
        }
    }
}

private extension GameForLoadingCell {

    private func setupViews() {
        addSubview(playersLabel)
        addSubview(dateAndDelete)

        dateAndDelete.distribution = .equalSpacing

        playersLabel.axis = .vertical
        dateAndDelete.axis = .horizontal

        dateAndDelete.addArrangedSubview(dateLabel)
        dateAndDelete.addArrangedSubview(deleteButton)
    }
}
