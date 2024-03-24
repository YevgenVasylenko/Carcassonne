//
//  LoadMenuViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.06.2023.
//

import UIKit

class LoadMenuViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var data = GameCoreDAO.getAllGamesAndDates()

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GameForLoadingView.self, forCellWithReuseIdentifier: "\(GameForLoadingView.self)")
        collectionView.register(HeaderForLoadingView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "\(HeaderForLoadingView.self)")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GameForLoadingView.self)", for: indexPath) as! GameForLoadingView
        cell.data = data[indexPath.item]
        cell.deleteButtonAction = { [weak self] in
            self?.deleteCell(at: indexPath)
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderForLoadingView.self)", for: indexPath) as! HeaderForLoadingView
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        header.backgroundColor = .white
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 20.5 * CGFloat(data[indexPath.item].0.players.count))
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showAlertForCell(at: indexPath)
    }

    private func deleteCell(at indexPath: IndexPath) {
        GameCoreDAO.delete(game: data[indexPath.item].0)
        data.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }

    private func showAlertForCell(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Are you sure you want to load this game", message: nil, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let gameViewController = storyBoard.instantiateViewController(withIdentifier: "\(GameViewController.self)") as! GameViewController
            gameViewController.loadViewIfNeeded()
            gameViewController.game = self.data[indexPath.item].0
            let navigationController = self.presentingViewController as? UINavigationController
            self.dismiss(animated: true)
            navigationController?.pushViewController(gameViewController, animated: true)
        }))

        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

final class GameForLoadingView: UICollectionViewCell {

    var deleteButtonAction: (() -> Void)?

    var data: (GameCore, Date)? {
        didSet {
            guard let data = data else { return }
            configure(data: data)
        }
    }
}

private extension GameForLoadingView {
    
    func configure(data: (GameCore, Date)) {
        let gameDataLabel = ContainerListOfGamesForLoadingView(data: data)

        gameDataLabel.deleteButtonAction = { [weak self] in
            self?.deleteButtonTapped()
        }

        addSubview(gameDataLabel)

        gameDataLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameDataLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            gameDataLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            gameDataLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func deleteButtonTapped() {
        deleteButtonAction?()
    }
}
