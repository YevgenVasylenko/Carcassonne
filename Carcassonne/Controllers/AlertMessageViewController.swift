//
//  AlertMessageViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 02.05.2024.
//

import UIKit

final class AlertMessageViewController: UIViewController {

    let message: String
    let actionOnYes: () -> ()
    let actionOnNo: () -> ()

    init(message: String, actionOnYes: @escaping () -> (), actionOnNo: @escaping () -> ()) {
        self.message = message
        self.actionOnYes = actionOnYes
        self.actionOnNo = actionOnNo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        view = UIImageView(image: UIImage(named: "readyScroll"))
        view.isUserInteractionEnabled = true

        let overallContainer = UIStackView()
        let buttonsContainer = UIStackView()

        overallContainer.axis = .vertical
        overallContainer.distribution = .fillProportionally
        overallContainer.isLayoutMarginsRelativeArrangement = true
        overallContainer.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)

        buttonsContainer.axis = .horizontal
        buttonsContainer.distribution = .fillEqually

        let alertMessage = UILabel()

        alertMessage.text = message
        alertMessage.font = UIFont(name: "GoudyThirty-Light", size: 24)
        alertMessage.numberOfLines = 2
        alertMessage.textAlignment = .center

        let yesButton = UIButton(configuration: makeButtonConfiguration(buttonName: "Yes"))
        yesButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.actionOnYes()
            }
        }), for: .touchUpInside)

        let noButton = UIButton(configuration: makeButtonConfiguration(buttonName: "No"))
        noButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.actionOnNo()
            }
        }), for: .touchUpInside)

        buttonsContainer.addArrangedSubview(yesButton)
        buttonsContainer.addArrangedSubview(noButton)

        overallContainer.addArrangedSubview(alertMessage)
        overallContainer.addArrangedSubview(buttonsContainer)

        view.addSubview(overallContainer)

        overallContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overallContainer.topAnchor.constraint(equalTo: view.topAnchor),
            overallContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overallContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            overallContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

private extension AlertMessageViewController {

    func makeButtonConfiguration(buttonName: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = .init(buttonName, attributes: .init([
            .font: UIFont(name: "GoudyThirty-Light", size: 24)!,
            .foregroundColor: UIColor(.black)
        ]))
        config.titleAlignment = .center

        return config
    }
}

extension AlertMessageViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        AlertMessageViewControllerPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertViewTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AlertViewTransitionAnimator()
    }
}
