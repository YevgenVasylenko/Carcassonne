//
//  LoadingViewTransitionAnimator.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 26.04.2024.
//

import UIKit

final class LoadingViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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

private extension LoadingViewTransitionAnimator {
    func presentAnimation(toVC: UIViewController, transitionContext: UIViewControllerContextTransitioning) {

        toVC.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
        transitionContext.containerView.addSubview(toVC.view)
        var transform3D = CATransform3DIdentity
        transform3D.m34 = -1 / 700
        let rotation = CATransform3DRotate(transform3D, -90, 1, 0, 0)
        toVC.view.transform3D = rotation

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 5,
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
            withDuration: 0.8,
            delay: 0,
            options: [.curveEaseIn]
        ) {
            fromVC.view.layer.anchorPoint = CGPoint(x: 1, y: 1)
            var transform3D = CATransform3DIdentity
            transform3D.m34 = -1 / 1500
            let rotation = CATransform3DRotate(transform3D, -90, 1, 0, 0)
            fromVC.view.transform3D = rotation
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
