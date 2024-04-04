//
//  StartMenuView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 01.04.2024.
//

import UIKit

enum StartMenuButton: CaseIterable {
    case continueButton
    case startNewGameButton
    case loadGameButton
    case settingsButton
}

final class StartMenuView: UIView {

    let buttonAction: (StartMenuButton) -> ()
    
    init(buttonAction: @escaping (StartMenuButton) -> ()) {
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

        let image = UIImageView(image: UIImage(named: "shield"))
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        addSubview(image)

        let container = UIStackView()
        image.addSubview(container)
        container.axis = .vertical

        for button in StartMenuButton.allCases {
            let menuButton = UIButton(configuration: makeButtonConfiguration(button: button))

            menuButton.addAction(UIAction(handler: { [weak self] _ in
                self?.buttonAction(button)
            }), for: .touchUpInside)

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

        func makeButtonConfiguration(button: StartMenuButton) -> UIButton.Configuration {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = .init(buttonName(button: button), attributes: .init([
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Moyenage", size: 20)!
            ]))
            config.background.image = UIImage(named: "sign")
            config.buttonSize = .large
            return config
        }

        func buttonName(button: StartMenuButton) -> String {
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
