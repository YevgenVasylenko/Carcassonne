//
//  Meeple.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 02.05.2023.
//

import Foundation

enum MeepleType {
    case thief
    case knight
    case monk
}

struct Meeple {
    
    var possition: LandType
    var type: MeepleType

}
