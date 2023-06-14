//
//  Player.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import Foundation
import UIKit

struct Player: Hashable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
            return lhs.name == rhs.name
        }
    
    var name: String = ""
    var score: Int = 0
    var color: UIColor?
    
}
