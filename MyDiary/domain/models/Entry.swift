//
//  File.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 03.08.2023.
//

import Foundation

struct Entry {
    let id: Int
    let type: Int
    let time: Double
}

func makeRandomEntry() -> Entry {
    let type = Int.random(in: 1...6)
    let currentTime = Date().timeIntervalSince1970 * 1000
    let time = Double.random(in: 0...currentTime)
    return Entry(id: 0, type: type, time: time)
}

func makeEntry(type: Int) -> Entry {
    let currentTime = Date().timeIntervalSince1970 * 1000
    return Entry(id: 0, type: type, time: currentTime)
}

func makeEntry(type: Int, date: Date) -> Entry {
    let time = date.timeIntervalSince1970 * 1000
    return Entry(id: 0, type: type, time: time)
}

func formatTimeForList(entry: Entry) -> String {
    let timeIntervalSince1970 = entry.time / 1000.0
    let date = Date(timeIntervalSince1970: timeIntervalSince1970)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    return dateFormatter.string(from: date)
}

func formatTimeTop(entry: Entry) -> String {
    let dt = Int64(Date().timeIntervalSince1970 * 1000 - entry.time)
    let secTotal = dt / 1000
    let sec = secTotal % 60
    let minTotal = secTotal / 60
    let min = minTotal % 60
    let hoursTotal = minTotal / 60
    let hours = hoursTotal % 24
    let days = hoursTotal / 24
    
    if (days > 0) {
        return "\(days) d. \(hours) h. ago"
    } else if (hours > 0) {
        return "\(hours) h. \(min) m. ago"
    } else {
        return "\(min) m. \(sec) s. ago"
    }
}
