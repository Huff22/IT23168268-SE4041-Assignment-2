//
//  PantryItem.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//
import Foundation
import SwiftData

@Model
final class PantryItem {
    var id: UUID
    var name: String
    var dateAdded: Date
    
    init(name: String, dateAdded: Date = .now) {
        self.id = UUID()
        self.name = name
        self.dateAdded = dateAdded
    }
}
