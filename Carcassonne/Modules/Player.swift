//
//  Player.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import Foundation
import UIKit

enum PlayerColor: Codable, CaseIterable {
    case none
    case red
    case yellow
    case green
    case blue
    case black

    func getColor() -> UIColor {
        switch self {
        case .none:
            return .gray
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .green:
            return .green
        case .blue:
            return .blue
        case .black:
            return .black
        }
    }
}

struct Player: Hashable, Codable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.color == rhs.color
    }
    var id = UUID()
    var name: String = ""
    var score: Int = 0
    var color: PlayerColor = .none
    var availableMeeples = 7
}

extension Player {
    func isReadyForStartGame() -> Bool {
        !name.isEmpty && color != .none
    }
}
