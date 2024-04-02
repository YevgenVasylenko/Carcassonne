//
//  StartMenuView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 01.04.2024.
//

import UIKit

enum StartMenuButtonAction {
    case continueButton
    case startNewGameButton
    case loadGameButton
    case settingsButton
}

final class StartMenuView: UIView {

    let buttonAction: (StartMenuButtonAction) -> ()
    
    init(buttonAction: @escaping (StartMenuButtonAction) -> ()) {
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        configure()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartMenuView {

    func configure() {
        let container = UIStackView()
        let continueButton = UIButton()
        let startNewGameButton = UIButton()
        let loadGameButton = UIButton()
        let settingsButton = UIButton()

        addSubview(container)
        container.addArrangedSubview(continueButton)
        container.addArrangedSubview(startNewGameButton)
        container.addArrangedSubview(loadGameButton)
        container.addArrangedSubview(settingsButton)

        container.axis = .vertical
        container.isLayoutMarginsRelativeArrangement = true
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        continueButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonAction(.continueButton)
        }), for: .touchUpInside)

        startNewGameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonAction(.startNewGameButton)
        }), for: .touchUpInside)

        loadGameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonAction(.loadGameButton)
        }), for: .touchUpInside)

        settingsButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonAction(.settingsButton)
        }), for: .touchUpInside)
    }
}
