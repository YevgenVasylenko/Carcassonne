//
//  GameForLoadingCellView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.03.2024.
//

import UIKit

final class GameForLoadingCellView: UICollectionViewCell {

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

    override var isSelected: Bool {
        didSet {
            selectedEffect(isSelected: isSelected)
        }
    }

    func configure(data: (GameCore, Date), deleteAction: @escaping () -> ()) {
        backgroundView = backgroundView()

        playersLabel.subviews.forEach { $0.removeFromSuperview() }
        playersLabel.spacing = 4

        dateLabel.text = "\(data.1.formatted(date: .numeric, time: .omitted))"
        dateLabel.font = UIFont(name: "GoudyThirty-Light", size: 20)!

        deleteButton.configuration = deleteButtonConfiguration()
        
        deleteButton.addAction(UIAction(handler: { _ in
            deleteAction()
        }), for: .touchUpInside)

        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        dateAndDelete.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            dateAndDelete.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            dateAndDelete.leadingAnchor.constraint(equalTo: playersLabel.trailingAnchor),
            dateAndDelete.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            dateAndDelete.centerYAnchor.constraint(equalTo: centerYAnchor),
            playersLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])

        for player in data.0.players {
            let playerNameAndColor = UIStackView()
            let colorPlayerIndicator = UIImageView()
            let playerName = UILabel()
            let score = UILabel()

            playersLabel.addArrangedSubview(playerNameAndColor)

            colorPlayerIndicator.image = UIImage(named: "splash")?
                .withTintColor(player.color.getColor(), renderingMode: .alwaysOriginal)
            colorPlayerIndicator.setContentHuggingPriority(.defaultLow, for: .horizontal)
            playerName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            playerName.text = "\(player.name)"
            playerName.font = UIFont(name: "GoudyThirty-Light", size: 20)!

            score.text = "\(player.score)"
            score.font = UIFont(name: "GoudyThirty-Light", size: 20)!

            playerNameAndColor.axis = .horizontal
            playerNameAndColor.setCustomSpacing(4, after: colorPlayerIndicator)

            playerNameAndColor.addArrangedSubview(colorPlayerIndicator)
            playerNameAndColor.addArrangedSubview(playerName)
            playerNameAndColor.addArrangedSubview(score)

            colorPlayerIndicator.translatesAutoresizingMaskIntoConstraints = false
            playerName.translatesAutoresizingMaskIntoConstraints = false
            score.translatesAutoresizingMaskIntoConstraints = false

            let colorPlayerIndicatorHeightConstraint = colorPlayerIndicator.heightAnchor.constraint(equalToConstant: 20)
            colorPlayerIndicatorHeightConstraint.priority = UILayoutPriority(999)

            NSLayoutConstraint.activate([
                colorPlayerIndicatorHeightConstraint,
                colorPlayerIndicator.widthAnchor.constraint(equalToConstant: 20),
                score.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/8),
            ])
        }
    }
}

private extension GameForLoadingCellView {

    func setupViews() {
        addSubview(playersLabel)
        addSubview(dateAndDelete)

        dateAndDelete.distribution = .equalSpacing

        playersLabel.axis = .vertical
        dateAndDelete.axis = .horizontal

        dateAndDelete.addArrangedSubview(dateLabel)
        dateAndDelete.addArrangedSubview(deleteButton)
    }

    func selectedEffect(isSelected: Bool) {
        let shadowOpacity: Float = isSelected ? 0 : 1
        backgroundView?.layer.shadowOpacity = shadowOpacity
    }

    func backgroundView() -> UIImageView {
        let backgroundView = UIImageView(image: UIImage(named: "readyScroll"))
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 1

        return backgroundView
    }

    func deleteButtonConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init("X", attributes: .init([
            .font: UIFont(name: "BetterBrush", size: 20)!,
            .foregroundColor: UIColor.red
        ]))

        return config
    }
}
