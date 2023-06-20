//
//  Player.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 15.05.2023.
//

import Foundation
import UIKit

struct Player: Hashable, Codable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
        }
    
    var name: String = ""
    var score: Int = 0
    @CodableColor var color: UIColor
    var availableMeeples = 7
}

@propertyWrapper
struct CodableColor {
    var wrappedValue: UIColor
}

extension CodableColor: Codable, Hashable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
