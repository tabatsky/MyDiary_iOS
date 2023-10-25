//
//  EntryRepository.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation

protocol EntryRepository {
    func getAll() -> [Entry]
    func add(entry: Entry)
    func delete(entry: Entry)
    func deleteAllOfType(type: Int)
}
