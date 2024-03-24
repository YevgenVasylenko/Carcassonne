//
//  HeaderForLoadingView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.03.2024.
//

import UIKit

final class HeaderForLoadingView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderForLoadingView {

    func configure() {
        let container = UIStackView()
        container.axis = .horizontal

        let players = UILabel()
        let score = UILabel()
        let date = UILabel()

        container.addArrangedSubview(players)
        container.addArrangedSubview(score)
        container.addArrangedSubview(date)

        addSubview(container)

        players.text = "Players"
        score.text = "Score"
        date.text = "Date"

        players.font = .systemFont(ofSize: 30)
        score.font = .systemFont(ofSize: 20)
        date.font = .systemFont(ofSize: 20)

        players.translatesAutoresizingMaskIntoConstraints = false
        score.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            players.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            score.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1/8),
            score.trailingAnchor.constraint(equalTo: date.leadingAnchor),
            date.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1/4),
            date.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
}
