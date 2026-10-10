//
//  Item.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
