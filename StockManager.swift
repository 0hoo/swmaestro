//
//  StockManager.swift
//  MyStock
//
//  Created by Kim Younghoo on 8/23/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import Foundation
import SQLite

final class StockManager {
    private static let TABLE_NAME = "stocks"
    
    static let table = Table(TABLE_NAME)
    static let stockId = Expression<Int64>("stockId")
    static let code = Expression<String>("code")
    static let name = Expression<String>("name")
    static let currentPrice = Expression<Double>("price")
    static let isPriceKeep = Expression<Bool>("isPriceKeep")
    static let isPriceUp = Expression<Bool>("isPriceUp")
    static let priceDiff = Expression<Double>("priceDiff")
    static let rateDiff = Expression<Double>("rateDiff")
    
    static func dropTable() throws {
        guard let db = Store.shared.db else { throw DataAccessError.DatastoreConnectionError }
        try db.run(table.delete())
    }
    
    static func createTable() throws {
        guard let db = Store.shared.db else { throw DataAccessError.DatastoreConnectionError }
        
        try db.run(table.create(ifNotExists: true) { t in
            t.column(stockId, primaryKey: true)
            t.column(code)
            t.column(name)
            t.column(currentPrice)
            t.column(isPriceKeep)
            t.column(isPriceUp)
            t.column(priceDiff)
            t.column(rateDiff)
        })
    }
    
    static func findAll() -> [Stock] {
        guard let db = Store.shared.db else { return [] }
        
        do {
            return try db.prepare(table.order(name.desc))
                .map { Stock(stockId: $0[stockId], code: $0[code], name: $0[name], currentPrice: $0[currentPrice], priceDiff: $0[priceDiff], rateDiff: $0[rateDiff], isPriceUp: $0[isPriceUp], isPriceKeep: $0[isPriceKeep]) }
        } catch {
            print(error)
            return []
        }
    }
    
    static func save(_ entry: Stock) {
        guard let db = Store.shared.db else { return }
        
        do {
            if let stockIdValue = entry.stockId {
                let stockToUpdate = table.filter(stockId == stockIdValue)
                try db.run(stockToUpdate.update(code <- entry.code, name <- entry.name, currentPrice <- entry.currentPrice, isPriceKeep <- entry.isPriceKeep, isPriceUp <- entry.isPriceUp, priceDiff <- entry.priceDiff, rateDiff <- entry.rateDiff))
            } else {
                try entry.stockId = db.run(table.insert(code <- entry.code, name <- entry.name, currentPrice <- entry.currentPrice, isPriceKeep <- entry.isPriceKeep, isPriceUp <- entry.isPriceUp, priceDiff <- entry.priceDiff, rateDiff <- entry.rateDiff))
            }
        } catch {
            print(error)
        }
    }
}
