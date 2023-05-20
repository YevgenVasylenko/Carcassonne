//
//  StartNewGameViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import UIKit

class StartNewGameViewController: UIViewController {
    
    private var playersLabels: [NewPlayerEditingLabel] = []
    
    private var players: [Player] = []
    
    @IBOutlet var playerList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerList.backgroundColor = .systemGray
    }
    
    @IBAction func addPlayerButton() {
        let playerView = NewPlayerEditingLabel()
        playersLabels.append(playerView)
        playerList.addArrangedSubview(playerView)
    }
    
    @IBAction func startGameButton() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "\(GameViewController.self)") {
            if let gameViewController = segue.destination as? GameViewController {
                fillUpPlayersList()
                gameViewController.loadViewIfNeeded()
                gameViewController.game.players = players
            }
        }
    }
    
    func fillUpPlayersList() {
        for player in playersLabels {
            let name = player.getPlayerName ?? ""
            let color = player.getColor
            players.append(Player(name: name, color: color))
        }
    }
}

class NewPlayerEditingLabel: UIStackView {
    
    private let playerName = UITextField()
    private let playerColor = UIColorWell()
    private let deletePlayerButton = UIButton()
    
    var getPlayerName: String? {
        playerName.text
    }
    
    var getColor: UIColor? {
        playerColor.selectedColor
        
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        self.axis = .horizontal
        
        playerName.frame.size = CGSizeMake(100, 50)
        playerName.backgroundColor = .cyan
        playerName.placeholder = "Player Name"
        
        playerColor.frame.size = CGSize(width: 50, height: 50)
        
        deletePlayerButton.frame.size = CGSize(width: 50, height: 50)
        deletePlayerButton.backgroundColor = .darkGray
        deletePlayerButton.setImage(UIImage(named: "trash"), for: .normal)
        
        self.addArrangedSubview(playerName)
        self.addArrangedSubview(playerColor)
        self.addArrangedSubview(deletePlayerButton)
        
    }
}
