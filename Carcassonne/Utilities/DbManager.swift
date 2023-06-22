//
//  File.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 21.06.2023.
//

import Foundation
import SQLite

//struct Connection{}

final class DBManager {
    static let shared = DBManager()
    
    let connection: Connection
    
    private init() {
        connection = Self.makeConnection()
        createDBStructure()
    }
    
    private static func makeConnection() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        return try! Connection("\(path)/db.sqlite3")
    }
    
    private func createDBStructure() {
        do {
            try connection.run(GameCoreDAO.create())
        } catch { }
    }
}

struct GameCoreDAO {
    
    enum Error {
        
    }
    
    enum Scheme {
        static let games = Table("games")
        static let id = Expression<Int64>("id")
        static let game = Expression<GameCore>("game")
        static let date = Expression<Date>("date")
    }
    
    static func create() -> String {
        return (Scheme.games.create(ifNotExists: true) { t in
            t.column(Scheme.id, primaryKey: .autoincrement)
            t.column(Scheme.game)
            t.column(Scheme.date, unique: true)
        })
    }
    
    static func getAllGamesAndDates() -> [(GameCore, Date)] {
        var allGamesAndDates: [(GameCore, Date)] = []
        do {
            for row in try DBManager.shared.connection.prepare(Scheme.games) {
                allGamesAndDates.append((row[Scheme.game], row[Scheme.date]))
            }
        } catch {
        }
        return allGamesAndDates
    }
    
    static func saveGame(game: GameCore) {
        do {
            try DBManager.shared.connection.run(Scheme.games.insert(Scheme.game <- game, Scheme.date <- .now))
        } catch {
            print("insertion failed: \(error)")
        }
    }
    
    static func delete(date: Date) {
        do {
            let filteredGames = Scheme.games.filter(Scheme.date == date)
            try DBManager.shared.connection.run(filteredGames.delete())
        } catch {
        }
    }
}
