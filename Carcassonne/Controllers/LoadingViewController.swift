//
//  LoadMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.06.2023.
//

import UIKit

final class LoadingViewController: UICollectionViewController {
    private var data = GameCoreDAO.getAllGamesAndDates()
    var actionOnDisappear: (() -> Void)?

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: Self.createLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(GameForLoadingCellView.self, forCellWithReuseIdentifier: "\(GameForLoadingCellView.self)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        actionOnDisappear?()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GameForLoadingCellView.self)", for: indexPath) as! GameForLoadingCellView
        cell.configure(data: data[indexPath.item]) { [weak self] in
            self?.showAlertForDeleting(at: indexPath)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = self.data[indexPath.item].0

        showAlertForLoading(game: game) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

private extension LoadingViewController {

    func setupViews() {

        view = UIImageView(image: UIImage(named: "LoadMenuBackground"))
        view.isUserInteractionEnabled = true
        
        let header = HeaderForLoadingView()

        collectionView.backgroundColor = .clear
        header.backgroundColor = .clear

        view.addSubview(header)
        view.addSubview(collectionView)

        header.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 22),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.4),
        ])
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _,_ in
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(300)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitems: [NSCollectionLayoutItem(layoutSize: layoutSize)]
            )

            let layout = NSCollectionLayoutSection(group: group)
            layout.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            layout.interGroupSpacing = 8

            return layout
        }
    }

    func showAlertForLoading(
        game: GameCore,
        deselectCell: @escaping () -> Void
    ) {
        let alertController = UIAlertController(
            title: "Are you sure you want to load this game",
            message: nil,
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
            title: "Yes",
            style: .default,
            handler: { [weak self] _ in
            guard let self else { return }

            let gameViewController: GameViewController =  UIStoryboard.makeViewController()
            gameViewController.loadViewIfNeeded()
            gameViewController.game = game

            let navigationController = self.presentingViewController as? UINavigationController

            self.dismiss(animated: true) {
                let startMenuViewController = MainMenuViewController()
                navigationController?.setViewControllers([startMenuViewController, gameViewController], animated: true)
            }
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            deselectCell()
        }))

        self.present(alertController, animated: true, completion: nil)
    }

    func showAlertForDeleting(at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Are you sure you want to delete save game",
            message: nil,
            preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            GameCoreDAO.delete(game: self.data[indexPath.item].0)
            self.data.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension LoadingViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        LoadingViewPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        LoadingViewTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        LoadingViewTransitionAnimator()
    }
}
