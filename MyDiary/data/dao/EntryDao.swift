//
//  EntryDao.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation
import GRDB

final class EntryDao {
    private let dbQueue: DatabaseQueue
    
    init() {
//        let databaseURL = try! FileManager.default
//                    .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let databaseURL = try! FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            create: true
        )
                    .appendingPathComponent("MyDiary.sqlite")
        dbQueue = try! DatabaseQueue(path: databaseURL.path())
        createTableIfNotExists()
    }
    
    func createTableIfNotExists() {
        try! dbQueue.write { db in
            try! db.create(table: "entryEntity", ifNotExists: true) { t in
                t.column("id", .integer).primaryKey(autoincrement: true)
                t.column("type", .integer)
                t.column("time", .double)
            }
        }
    }
    
    func getAll() -> [EntryEntity] {
        let entries: [EntryEntity] = try! dbQueue.read { db in
            try! EntryEntity
                .select(literal: "*")
                .order(SQL("time").sqlExpression)
                .reversed()
                .fetchAll(db)
        }
        return entries
    }
    
    func add(entryEntity: EntryEntity) {
        try! dbQueue.write { db in
            try! entryEntity.insert(db)
        }
    }
    
    func delete(entryEntity: EntryEntity) {
        try! dbQueue.write { db in
            try! entryEntity.delete(db)
        }
    }
    
    func deleteAllOfType(type: Int) {
        try! dbQueue.write { db in
            try! db.execute(sql: "DELETE FROM entryEntity WHERE type=?",
                            arguments: [type])
        }
    }
}
