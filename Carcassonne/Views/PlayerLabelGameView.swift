//
//  PlayerLabelGameView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 19.05.2023.
//

import UIKit
import SwiftUI

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
        self.axis = .vertical
        self.spacing = 4
        
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
        labelsOfNameAndScoreNumber.alignment = .leading
        nameLabel.text = player.name
        scoreLabel.text = "\(player.score)"
        labelsOfNameAndScoreNumber.addArrangedSubview(nameLabel)
        labelsOfNameAndScoreNumber.addArrangedSubview(scoreLabel)
        
        let meeplePictureAndNameScore = UIStackView()
        meeplePictureAndNameScore.axis = .horizontal
        meeplePictureAndNameScore.spacing = 4
        
        meeplePictureAndNameScore.addArrangedSubview(meeplePictureWithPlayerColor)
        meeplePictureAndNameScore.addArrangedSubview(labelsOfPlayerAndScore)
        meeplePictureAndNameScore.addArrangedSubview(labelsOfNameAndScoreNumber)
        
        let picturesOfAvailableMeeples = UIStackView()
        picturesOfAvailableMeeples.axis = .horizontal
        picturesOfAvailableMeeples.distribution = .fill
        if player.availableMeeples != 0 {
            for _ in 0...max(0, player.availableMeeples - 1) {
                let smallMeeplePicture = UIImageView(
                    image: UIImage(named: "meeple")?
                        .withTintColor(player.color ?? .black))
                smallMeeplePicture.contentMode = .scaleAspectFit
                smallMeeplePicture.widthAnchor.constraint(equalToConstant: 20).isActive = true
                smallMeeplePicture.heightAnchor.constraint(equalToConstant: 20).isActive = true
                picturesOfAvailableMeeples.addArrangedSubview(smallMeeplePicture)
            }
        }
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        
        // stackView.addArrangedSubview.... any u need
        picturesOfAvailableMeeples.addArrangedSubview(spacer)
        
        self.addArrangedSubview(meeplePictureAndNameScore)
        self.addArrangedSubview(picturesOfAvailableMeeples)
        
        NSLayoutConstraint.activate([
            meeplePictureWithPlayerColor.widthAnchor.constraint(equalToConstant: 50),
            meeplePictureWithPlayerColor.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    func makeShadow() {
        self.layer.shadowColor = .init(red: 0, green: 0, blue: 1, alpha: 1)
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.clipsToBounds = false

    }
}

#if DEBUG

//struct PlayerLabelGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        UIViewPreview(
//            PlayerLabelGameView(player: Player())
//        )
//        .frame(width: 200, height: 75)
//    }
//}

#endif
