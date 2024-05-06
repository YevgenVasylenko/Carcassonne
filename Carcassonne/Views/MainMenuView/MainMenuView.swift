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
    private let container = UIStackView()

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

        image.addSubview(container)
        container.axis = .vertical

        makeButtons()

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
    }

    func makeButtons() {
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for button in StartMenuAction.allCases {

            let menuButton = UIButton(configuration: makeButtonConfiguration(button: button))
            menuButton.isEnabled = button.isActionAvailableWithoutSaveGame()

            menuButton.addAction(UIAction(handler: { [weak self] _ in
                self?.buttonAction?(button)
            }), for: .touchUpInside)
            menuButtonUpdateHandler(button: menuButton)

            container.addArrangedSubview(menuButton)
        }
    }
}

private extension MainMenuView {

    func makeButtonConfiguration(button: StartMenuAction) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(buttonName(button: button), attributes: .init([
            .font: UIFont(name: "Moyenage", size: 20)!
        ]))
        let backgroundImage = UIImageView(image: UIImage(named: "sign"))
        config.background.customView = backgroundImage
        config.buttonSize = .large

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

    func menuButtonUpdateHandler(button: UIButton) {
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                UIView.animate(withDuration: 0.25) {
                    button.configuration?.background.customView?.transform = .init(scaleX: 1.1, y: 1.1)
                }
            case .disabled:
                button.configuration?.attributedTitle?.foregroundColor = .gray.withAlphaComponent(0.7)
            default:
                button.configuration?.background.customView?.transform = .identity
                button.configuration?.attributedTitle?.foregroundColor = UIColor.black
            }
        }
    }
}
