//
//  EntryRepositoryImpl.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation

final class EntryRepositoryImpl: EntryRepository {
    private let entryDao: EntryDao
    
    init() {
        entryDao = EntryDao()
    }
    
    func getAll() -> [Entry] {
        return entryDao.getAll().map { $0.toModel() }
    }
    
    func add(entry: Entry) {
        entryDao.add(entryEntity: entry.toEntity())
    }
    
    func delete(entry: Entry) {
        entryDao.delete(entryEntity: entry.toEntity())
    }
    
    func deleteAllOfType(type: Int) {
        entryDao.deleteAllOfType(type: type)
    }
}
