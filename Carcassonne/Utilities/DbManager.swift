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

    enum Scheme {
        static let games = Table("games")
        static let id = Expression<UUID>("id")
        static let game = Expression<GameCore>("game")
        static let date = Expression<Date>("date")
    }

    static func getAllGamesAndDates() -> [(GameCore, Date)] {
        var allGamesAndDates: [(GameCore, Date)] = []
        do {
            for row in try DBManager.shared.connection.prepare(Scheme.games) {
                allGamesAndDates.append((row[Scheme.game], row[Scheme.date]))
            }
        } catch {
            print("db failed: \(error)")
        }
        allGamesAndDates.sort {
            $0.1 < $1.1
        }
        return allGamesAndDates
    }

    static func delete(game: GameCore) {
        do {
            let filteredGames = Scheme.games.filter(Scheme.id == game.id)
            try DBManager.shared.connection.run(filteredGames.delete())
        } catch {
            print("delete failed: \(error)")
        }
    }

    static func saveOrUpdateGame(game: GameCore) {
        do {
            try DBManager.shared.connection.run(Scheme.games.upsert(
                Scheme.id <- game.id,
                Scheme.game <- game,
                Scheme.date <- .now,
                onConflictOf: Scheme.id))
        } catch {
            print("upsert failed: \(error)")
        }
    }

    static func getLastGame() -> GameCore? {
        var lastGame: GameCore?
        do {
            let lastGameDate = Scheme.games.order(Scheme.date.desc).limit(1)
            for game in try DBManager.shared.connection.prepare(lastGameDate) {
                lastGame = game[Scheme.game]
            }
        } catch {
            print("db failed: \(error)")
        }
        return lastGame
    }
}

private extension GameCoreDAO {

    static func create() -> String {
        return (Scheme.games.create(ifNotExists: true) { t in
            t.column(Scheme.id, unique: true)
            t.column(Scheme.game)
            t.column(Scheme.date, unique: true)
        })
    }
}
