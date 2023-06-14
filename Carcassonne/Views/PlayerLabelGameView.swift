//
//  PlayerLabelGameView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.05.2023.
//

import UIKit

class PlayerLabelGameView: UIStackView {
    private let meeplePictureWithPlayerColor = UIImageView()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    
    init(player: Player) {
        super .init(frame: .zero)
        configure(player: player)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(player: Player) {
        self.axis = .horizontal
        
        meeplePictureWithPlayerColor.image = UIImage(named: "meeple")?.withTintColor(player.color ?? .black)
        
        let labelsOfPlayerAndScore = UIStackView()
        labelsOfPlayerAndScore.axis = .vertical
        let playerName = UILabel()
        playerName.text = "Player: "
        let score = UILabel()
        score.text = "Score: "
        labelsOfPlayerAndScore.addArrangedSubview(playerName)
        labelsOfPlayerAndScore.addArrangedSubview(score)
        
        let labelsOfNameAndScoreNumber = UIStackView()
        labelsOfNameAndScoreNumber.axis = .vertical
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
        labelsOfNameAndScoreNumber.addArrangedSubview(nameLabel)
        labelsOfNameAndScoreNumber.addArrangedSubview(scoreLabel)
        
        self.addArrangedSubview(meeplePictureWithPlayerColor)
        self.addArrangedSubview(labelsOfPlayerAndScore)
        self.addArrangedSubview(labelsOfNameAndScoreNumber)
        
        NSLayoutConstraint.activate([
            meeplePictureWithPlayerColor.widthAnchor.constraint(equalToConstant: 50),
            meeplePictureWithPlayerColor.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
