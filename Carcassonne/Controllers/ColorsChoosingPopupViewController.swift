//
//  ColorsChoosingPopupViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class ColorsChoosingPopupViewController: UIViewController {

    private var availablePlayerColors: [PlayerColor]
    private let completion: (PlayerColor) -> Void

    init(availablePlayerColors: [PlayerColor], completion: @escaping (PlayerColor) -> Void) {
        self.availablePlayerColors = availablePlayerColors
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ColorsChoosingPopupViewController {

    func configure() {
        let colorsList = UIStackView()
        colorsList.axis = .vertical
        view.addSubview(colorsList)

        for color in availablePlayerColors {
            let colorButton = UIButton()
            colorButton.backgroundColor = color.getColor()

            colorsList.addArrangedSubview(colorButton)

            colorButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                colorButton.heightAnchor.constraint(
                    equalTo: colorsList.heightAnchor,
                    multiplier: 1 / CGFloat(availablePlayerColors.count)
                ),
                colorButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])

            colorButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.completion(color)
                self.dismiss(animated: true)
            }), for: .touchUpInside)
        }

        colorsList.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorsList.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
}
