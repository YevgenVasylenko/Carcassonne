//
//  MainMenuView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 01.04.2024.
//

import UIKit

enum StartMenuAction: CaseIterable {
    case continueButton
    case startNewGameButton
    case loadGameButton
    case settingsButton

    func isActionAvailableWithoutSaveGame() -> Bool {
        switch self {
        case .continueButton:
            return GameCoreDAO.getLastGame() != nil
        case .startNewGameButton:
            return true
        case .loadGameButton:
            return GameCoreDAO.getLastGame() != nil
        case .settingsButton:
            return true
        }
    }
}

final class MainMenuView: UIView {

    var buttonAction: ((StartMenuAction) -> ())?
    
    init() {
        super.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {

        let image = UIImageView(image: UIImage(named: "shield"))
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        addSubview(image)

        let container = UIStackView()
        image.addSubview(container)
        container.axis = .vertical

        for button in StartMenuAction.allCases {
            let menuButton = UIButton(configuration: makeButtonConfiguration(button: button))

            menuButton.addAction(UIAction(handler: { [weak self] _ in
                self?.buttonAction?(button)
            }), for: .touchUpInside)

            menuButton.isEnabled = button.isActionAvailableWithoutSaveGame()
            container.addArrangedSubview(menuButton)
        }

        image.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),

            container.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -image.frame.height * 0.045)
        ])

        func makeButtonConfiguration(button: StartMenuAction) -> UIButton.Configuration {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = .init(buttonName(button: button), attributes: .init([
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Moyenage", size: 20)!
            ]))
            let backgroundImage = UIImage(named: "sign")
            config.background.image = backgroundImage
            config.buttonSize = .large

            if !button.isActionAvailableWithoutSaveGame() {
                config.attributedTitle?.foregroundColor = .gray.withAlphaComponent(0.7)
            }

            return config
        }

        func buttonName(button: StartMenuAction) -> String {
            switch button {
            case .continueButton:
                return "Continue"
            case .startNewGameButton:
                return "Start New Game"
            case .loadGameButton:
                return "Load Game"
            case .settingsButton:
                return "Settings"
            }
        }
    }
}
