//
//  ContainerListOfGamesForLoadingView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.03.2024.
//

import UIKit

final class ContainerListOfGamesForLoadingView: UIStackView {

    var deleteButtonAction: (() -> Void)?

    init(data: (GameCore, Date)) {
        super.init(frame: .zero)
        configure(data: data)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContainerListOfGamesForLoadingView {

    func configure(data: (GameCore, Date)) {
        axis = .vertical

        let savedGameWithSeparator = UIStackView()
        savedGameWithSeparator.axis = .vertical

        let savedGameLabel = GameLabelForLoadingMenuView(
            players: data.0.players,
            date: data.1
        )
        savedGameLabel.deleteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.deleteButtonAction?()
        }), for: .touchUpInside)

        let separator = UIView()
        separator.backgroundColor = .gray

        savedGameWithSeparator.addArrangedSubview(savedGameLabel)
        savedGameWithSeparator.addArrangedSubview(separator)

        savedGameLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            savedGameLabel.topAnchor.constraint(equalTo: savedGameWithSeparator.topAnchor, constant: 10),
            savedGameLabel.leadingAnchor.constraint(equalTo: savedGameWithSeparator.leadingAnchor),

            separator.topAnchor.constraint(equalTo: savedGameLabel.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: savedGameWithSeparator.leadingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: savedGameWithSeparator.bottomAnchor),
        ])
        addArrangedSubview(savedGameWithSeparator)
    }
}

