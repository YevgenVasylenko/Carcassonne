//
//  InGameMenuController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 18.06.2023.
//

import UIKit
import SQLite

class InGameMenuController: UIViewController {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
    ).first!

    
    
    var game: GameCore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDbWithTable()
    }
    
    @IBAction func SaveGameButton() {
        do {
            let db = try! Connection("\(path)/db.sqlite3")
            
            let games = Table("games")
            let id = Expression<Int64>("id")
            let game = Expression<GameCore>("game")
            let date = Expression<Int64>("date")
            
//            try! db.run(games.create { t in
//                t.column(id, primaryKey: true)
//                t.column(game)
//                t.column(date, unique: true)
//            })
            do {
                try db.run(games.insert(id <- 2, game <- game, date <- 5))
            } catch {
                print("insertion failed: \(error)")
            }

        }
    }
    
    func createDbWithTable() {
        do {
            let db = try! Connection("\(path)/db.sqlite3")
            
            let games = Table("games")
            let id = Expression<Int64>("id")
            let game = Expression<GameCore>("game")
            let date = Expression<Date>("date")
            
            try! db.run(games.create { t in
                t.column(id, primaryKey: true)
                t.column(game)
                t.column(date, unique: true)
            })
        }
    }
}
