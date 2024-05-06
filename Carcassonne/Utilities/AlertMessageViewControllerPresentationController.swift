//
//  AlertMessageViewControllerPresentationController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 02.05.2024.
//

import UIKit

final class AlertMessageViewControllerPresentationController: UIPresentationController {

    private lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        dimmingView.alpha = 0.0

        return dimmingView
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)

        frame.origin.y = containerView!.frame.height * 0.5 - frame.size.height * 0.5
        frame.origin.x = containerView!.frame.width * 0.5 - frame.size.width * 0.5
        return frame
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        containerView.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0.0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * 0.25, height: parentSize.height * 0.15)
    }
}

private extension AlertMessageViewControllerPresentationController {

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}

