//
//  StartButtonView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class StartButton: UIButton {

    private let minNumberOfPlayers = 2

    init(playersCount: Int, completion: @escaping () -> ()) {
        super.init(frame: .zero)
        configure(playersCount: playersCount, completion: completion)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartButton {

    func configure(playersCount: Int, completion: @escaping () -> ()) {

        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        setTitle("Start Game", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .blue
        layer.cornerRadius = 8
        configuration?.cornerStyle = .dynamic

        addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if playersCount >= self.minNumberOfPlayers {
                completion()
            } else {
                self.wiggle()
            }
        }), for: .touchUpInside)
    }
}
