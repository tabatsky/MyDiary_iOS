//
//  EntryConverters.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation

extension Entry {
    func toEntity() -> EntryEntity {
        let id = self.id > 0 ? self.id : nil
        return EntryEntity(id: id, type: self.type, time: self.time)
    }
}

extension EntryEntity {
    func toModel() -> Entry {
        return Entry(id: self.id!, type: self.type, time: self.time)
    }
}
