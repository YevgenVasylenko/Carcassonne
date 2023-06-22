//
//  GameLabelInLoadMenuView.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 20.06.2023.
//

import UIKit
import SwiftUI

class GameLabelInLoadMenuView: UIStackView {
    private let playersOfGameLabel = UILabel()
    private let dateLabel = UILabel()
    let deleteButton = UIButton()
    
    init(players: [Player], date: Date) {
        super .init(frame: .zero)
        configure(players: players, date: date)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(players: [Player], date: Date) {
        
        self.axis = .horizontal
        self.spacing = 4
        
        playersOfGameLabel.text = "Players: "
        self.addArrangedSubview(playersOfGameLabel)
        
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        
        for player in players {
            let playerName = UILabel()
            playerName.text = "\(player.name)"
            let colorPlayerIndicator: UIImageView = .init(image: UIImage(systemName: "circle.fill")?.withTintColor(player.color))
            let playerNameAndColor = UIStackView()
            playerNameAndColor.axis = .horizontal
            playerNameAndColor.addArrangedSubview(playerName)
            playerNameAndColor.addArrangedSubview(colorPlayerIndicator)
            
            self.addArrangedSubview(playerNameAndColor)
        }
        
        dateLabel.text = "\(date.formatted(date: .numeric, time: .standard))"
        self.addArrangedSubview(dateLabel)
        self.addArrangedSubview(deleteButton)
    }
}

struct GameLabelInLoadMenuView_Previews: PreviewProvider {

    static var previews: some View {
        let player = Player(color: .black)

        UIViewPreview(
            GameLabelInLoadMenuView(players: [player], date: .now)
        )
        .frame(width: 200, height: 75)
    }
}
