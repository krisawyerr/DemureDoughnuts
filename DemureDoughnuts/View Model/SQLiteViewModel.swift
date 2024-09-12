//
//  SQLiteViewModel.swift
//  DemureDoughnuts
//
//  Created by Kris Sawyerr on 9/12/24.
//

import Foundation
import SQLite

class SQLiteViewModel: ObservableObject {
    var db: Connection?

    init() {
        connect()
    }

    func connect() {
        do {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("db.sqlite3").path
            db = try Connection(path)
            print("Database connected")
            
            let tableExists = try db!.scalar("SELECT name FROM sqlite_master WHERE type='table' AND name='Cart';") != nil
            if !tableExists {
                createTable()
            } else {
                print("Table 'Cart' exists.")
            }
        } catch {
            print("Unable to connect to database: \(error)")
        }
    }
    
    func createTable() {
        do {
            let table = Table("Cart")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let image = Expression<String>("image")
            let cost = Expression<Double>("cost")
            let quantity = Expression<Int64>("quantity")
            
            try db?.run(table.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(image)
                t.column(cost)
                t.column(quantity)
            })
            print("Table created")
        } catch {
            print("Create table failed: \(error)")
        }
    }
    
    func isInCart(donut: DonutsModel, quantity: Int) {
        do {
            let table = Table("Cart")
            let name = Expression<String>("name")
            
            let query = table.filter(name == donut.name)
            
            if let _ = try db?.pluck(query) {
                update(donut: donut, newQuantity: quantity)
            } else {
                insert(donut: donut, quantity: quantity)
            }
        } catch {
            print("Query failed: \(error)")
        }
    }

    func insert(donut: DonutsModel, quantity: Int) {
        do {
            let table = Table("Cart")
            let nameExpr = Expression<String>("name")
            let imageExpr = Expression<String>("image")
            let costExpr = Expression<Double>("cost")
            let quantityExpr = Expression<Int64>("quantity")
            
            let insert = table.insert(nameExpr <- donut.name, imageExpr <- donut.image, costExpr <- donut.cost, quantityExpr <- Int64(quantity))
            try db?.run(insert)
            print("Inserted Item")
        } catch {
            print("Insert failed: \(error)")
        }
    }

    func query() -> [CartModel] {
        var results: [CartModel] = []
        do {
            let table = Table("Cart")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let image = Expression<String>("image")
            let cost = Expression<Double>("cost")
            let quantity = Expression<Int64>("quantity")

            for row in try db!.prepare(table) {
                results.append(CartModel(id: Int(row[id]), name: row[name], image: row[image], cost: row[cost], quantity: Int(row[quantity])))
            }
        } catch {
            print("Query failed: \(error)")
        }
        return results
    }

    func update(donut: DonutsModel, newQuantity: Int) {
        do {
            let table = Table("Cart")
            let name = Expression<String>("name")
            let quantity = Expression<Int64>("quantity")

            let recordToUpdate = table.filter(name == donut.name)
            
            if let currentRecord = try db?.pluck(recordToUpdate) {
                let currentQuantity = currentRecord[quantity]
                let updatedQuantity = currentQuantity + Int64(newQuantity)
                
                try db?.run(recordToUpdate.update(quantity <- updatedQuantity))
                print("Updated record with name \(donut.name) to new quantity \(updatedQuantity)")
            } else {
                print("No record found for \(donut.name)")
            }
        } catch {
            print("Update failed: \(error)")
        }
    }
    
    
    func update(donut: CartModel, function: String) {
        do {
            let table = Table("Cart")
            let name = Expression<String>("name")
            let quantity = Expression<Int64>("quantity")

            let recordToUpdate = table.filter(name == donut.name)
            
            if let currentRecord = try db?.pluck(recordToUpdate) {
                let currentQuantity = currentRecord[quantity]
                
                var updatedQuantity = currentQuantity
                if function == "add" {
                     updatedQuantity = currentQuantity + 1
                } else {
                     updatedQuantity = currentQuantity - 1
                }
                
                try db?.run(recordToUpdate.update(quantity <- updatedQuantity))
                print("Updated record with name \(donut.name) to new quantity \(updatedQuantity)")
            } else {
                print("No record found for \(donut.name)")
            }
        } catch {
            print("Update failed: \(error)")
        }
    }


    func delete(donut: CartModel) {
        do {
            let table = Table("Cart")
            let name = Expression<String>("name")

            let recordToDelete = table.filter(name == donut.name)
            try db?.run(recordToDelete.delete())
            print("Deleted record \(donut.name)")
        } catch {
            print("Delete failed: \(error)")
        }
    }
}
