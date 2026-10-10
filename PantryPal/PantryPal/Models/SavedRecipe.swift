//
//  SavedRecipe.swift
//  PantryPal
//
//  Created by Hafsa Faleel on 2026-10-10.
//

import Foundation
import SwiftData

@Model
final class SavedRecipe {
    var id: UUID
    var title: String
    var imageURL: String
    var instructions: String
    var prepTime: Int
    var isFavorite: Bool
    
    init(id: UUID = UUID(), title: String, imageURL: String, instructions: String, prepTime: Int, isFavorite: Bool = true) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.instructions = instructions
        self.prepTime = prepTime
        self.isFavorite = isFavorite
    }
}
