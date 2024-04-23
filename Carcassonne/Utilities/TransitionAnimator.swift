//
//  TransitionAnimator.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 23.04.2024.
//

import UIKit

final class TransitionAnimator: NSObject {
    private let duration: TimeInterval = 1
    private let presentingType: UINavigationController.Operation

    init(presentingType: UINavigationController.Operation) {
        self.presentingType = presentingType
    }
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        switch presentingType {
        case .push:
            toVC.view.transform = .init(translationX: 0, y: toVC.view.frame.height)
            transitionContext.containerView.addSubview(toVC.view)
            UIView.animate(
                withDuration: 0.5,
                delay: duration,
                options: .curveEaseInOut
            ) {
                toVC.view.transform = .identity
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
        case .pop:
            guard let snapshotFromVC = fromVC.view.snapshotView(afterScreenUpdates: false) else {
                return
            }

            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.containerView.addSubview(snapshotFromVC)
            fromVC.view.isHidden = true

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                snapshotFromVC.transform = .init(translationX: 0, y: fromVC.view.frame.height)
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
        case .none:
            break
        @unknown default:
            fatalError()
        }
    }
}
