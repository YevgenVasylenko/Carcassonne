//
//  StartButtonView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class StartButton: UIButton {

    var startGame: (() -> Void)?

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartButton {

    func configure() {

        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        setTitle("Start Game", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 8
        configuration?.cornerStyle = .dynamic

        addAction(UIAction(handler: { [weak self] _ in
            self?.startGame?()
        }), for: .touchUpInside)
    }
}
