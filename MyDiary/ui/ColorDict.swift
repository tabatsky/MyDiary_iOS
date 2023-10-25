//
//  ColorDict.swift
//  MyDiary
//
//  Created by Evgeny Tabatsky on 03.08.2023.
//

import Foundation
import SwiftUI

final class ColorDict {
    private static let INSTANCE = ColorDict()
    
    static func getColorByType(type: Int) -> Color {
        return INSTANCE.dict[type]!
    }
    
    private var dict: [Int:Color]
    
    private init() {
        let s = 0.4
        let v = 0.8
        
        dict = [Int:Color]()
        dict[1] = Color.init(hue: 0 / 6.0, saturation: s, brightness: v)
        dict[2] = Color.init(hue: 1 / 6.0, saturation: s, brightness: v)
        dict[3] = Color.init(hue: 2 / 6.0, saturation: s, brightness: v)
        dict[4] = Color.init(hue: 3 / 6.0, saturation: s, brightness: v)
        dict[5] = Color.init(hue: 4 / 6.0, saturation: s, brightness: v)
        dict[6] = Color.init(hue: 5 / 6.0, saturation: s, brightness: v)
    }
}

