//
//  NewPlayerEditingLabelView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.03.2024.
//

import UIKit

final class NewPlayerEditingLabelView: UIStackView {

    private let playerNameTextField = UITextField()
    let meepleColorChoiceButton = UIButton()

    init(
        player: Player,
        completion: @escaping (String) -> Void
    ) {
        super.init(frame: .zero)
        configure(
            player: player,
            completion: completion
        )
        playerNameTextField.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewPlayerEditingLabelView {

    func configure(
        player: Player,
        completion: @escaping (String) -> Void
    ) {
        axis = .vertical

        addArrangedSubview(playerNameTextField)
        addArrangedSubview(meepleColorChoiceButton)

        playerNameTextField.placeholder = "Player name"
        playerNameTextField.text = player.name
        playerNameTextField.addAction(UIAction(handler: { [weak self] _ in
            completion(self?.playerNameTextField.text ?? "")
        }), for: .editingDidEnd)

        meepleColorChoiceButton.setImage(UIImage(named: "meeple")?.withTintColor(player.color.getColor()), for: .normal)
        meepleColorChoiceButton.imageView?.contentMode = .scaleAspectFit

        playerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        meepleColorChoiceButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playerNameTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
            meepleColorChoiceButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2),
        ])
    }
}

extension NewPlayerEditingLabelView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
