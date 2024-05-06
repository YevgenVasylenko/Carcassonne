//
//  AlertViewTransitionAnimator.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 06.05.2024.
//

import UIKit

final class AlertViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }

        let isPresenting = toVC.isBeingPresented
        if isPresenting {
            presentAnimation(toVC: toVC, transitionContext: transitionContext)
        } else {
            dismissAnimation(fromVC: fromVC, transitionContext: transitionContext)
        }
    }
}

private extension AlertViewTransitionAnimator {

    func presentAnimation(
        toVC: UIViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {

        toVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 1)

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            toVC.view.transform = .identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }

    func dismissAnimation(
        fromVC: UIViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.curveEaseIn]
        ) {
            fromVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            fromVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 1)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
