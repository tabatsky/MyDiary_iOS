//
//  EntryEntity.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 04.08.2023.
//

import Foundation
import GRDB

struct EntryEntity: Codable, FetchableRecord, PersistableRecord {
    let id: Int?
    let type: Int
    let time: Double
}
