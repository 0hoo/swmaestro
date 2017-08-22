//
//  Store.swift
//  MyStock
//
//  Created by Kim Younghoo on 8/21/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import Foundation
import SQLite

enum DataAccessError: Error {
    case DatastoreConnectionError
}

final class Store {
    static let shared = Store()
    
    var dbFileName = "db.sqlite3"
    var db: Connection?
    
    init() {
        connectDb()
    }
    
    func connectDb() {
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first! + "/" + Bundle.main.bundleIdentifier!
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("Can't create a directory for MyStock app")
        }
        
        do {
            db = try Connection("\(path)/\(dbFileName)")
        } catch {
            db = nil
        }
    }
    
    func createTables() throws {
        do {
            try StockManager.createTable()
        } catch {
            print(error)
        }
    }
    
    func dropTables() throws {
        do {
            try StockManager.dropTable()
        } catch {
            print(error)
        }
    }
}
