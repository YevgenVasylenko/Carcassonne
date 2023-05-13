//
//  GameState+ButtonsAvailability.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 12.05.2023.
//

import Foundation

extension GameState {
    func isRotateEnabled() -> Bool {
        switch self {
        case .gameStart:
            return false
        case .currentTileOperate:
            return true
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return false
            case .meepleOperate:
                return false
            }
        }
    }
    
    func isMovingEnabled() -> Bool {
        switch self {
        case .gameStart:
            return false
        case .currentTileOperate:
            return true
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return false
            case .meepleOperate(_, let isPlaced):
                return !isPlaced
            }
        }
    }
    
    func isPlaceEnabled() -> Bool {
        switch self {
        case .gameStart:
            return false
        case .currentTileOperate(let isCanBePlace):
            return isCanBePlace
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return false
            case .meepleOperate(_, let isPlaced):
                return !isPlaced
            }
        }
    }
    
    func isPickupEnabled() -> Bool {
        switch self {
        case .gameStart:
            return false
        case .currentTileOperate:
            return false
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return true
            case .meepleOperate(_, let isPlaced):
                return isPlaced
            }
        }
    }
    
    func isNextTurnEnabled() -> Bool {
        switch self {
        case .gameStart:
            return true
        case .currentTileOperate:
            return  false
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return true
            case .meepleOperate(_, let isPlaced):
                return isPlaced
            }
        }
    }
    
    func isMeepleTileControlEnabled() -> Bool {
        switch self {
        case .gameStart:
            return true
        case .currentTileOperate:
            return false
        case .currentTileNotOperate(let meepleOperate):
            switch meepleOperate {
            case .meepleNotOperate:
                return true
            case .meepleOperate(_, let isPlaced):
                return !isPlaced
            }
        }
    }
}
