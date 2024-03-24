//
//  ScrollingListOfGamesForLoadingView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.03.2024.
//

import UIKit

final class ScrollingListOfGamesForLoadingView: UIScrollView {

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ScrollingListOfGamesForLoadingView {

    func configure() {
        showsVerticalScrollIndicator = false

//        let container = ContainerListOfGamesForLoadingView()
//        addSubview(container)

//        let heightConstraint = container.heightAnchor.constraint(equalTo: heightAnchor)
//        heightConstraint.priority = UILayoutPriority(250)
//
//        container.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            container.topAnchor.constraint(equalTo: topAnchor),
//            container.leadingAnchor.constraint(equalTo: leadingAnchor),
//            container.bottomAnchor.constraint(equalTo: bottomAnchor),
//            container.leadingAnchor.constraint(equalTo: leadingAnchor),
//            container.widthAnchor.constraint(equalTo: widthAnchor),
//            heightConstraint,
//        ])
    }
}
