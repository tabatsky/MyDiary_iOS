//
//  Deps.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation

final class Deps {
    private static let INSTANCE = Deps()
    
    private let entryRepository: EntryRepository
    
    private init() {
        entryRepository = EntryRepositoryImpl()
    }
    
    static func getEntryRepository() -> EntryRepository {
         return INSTANCE.entryRepository
    }
}
