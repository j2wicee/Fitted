//
//  Outfit.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//

import SwiftUI
import SwiftData
import Foundation
import UIKit

/// Represents a saved outfit - a collection of clothing items
/// 
/// **Architecture Decision:**
/// - Uses SwiftData's @Relationship to link to ClothingItem
/// - Many-to-many relationship: one outfit can have many items,
///   and one item can belong to many outfits
/// - Delete rule `.nullify` means if an item is deleted, it's
///   removed from outfits but outfits aren't deleted
@Model
final class Outfit {
    // MARK: - Core Properties
    
    /// User-given name for the outfit (e.g., "Casual Friday", "Date Night")
    var name: String
    
    /// When this outfit was created (useful for sorting by date)
    var dateCreated: Date
    
    // MARK: - Relationships
    
    /// The clothing items that make up this outfit
    /// 
    /// **Why @Relationship?**
    /// - SwiftData automatically manages the bidirectional link
    /// - When you add an item to an outfit, ClothingItem.outfits is updated automatically
    /// - `deleteRule: .nullify` means if an item is deleted, it's removed from this array
    ///   but the outfit itself remains (better UX than deleting the whole outfit)
    @Relationship(deleteRule: .nullify, inverse: \ClothingItem.outfits)
    var items: [ClothingItem] = []
    
    // MARK: - Optional Properties
    
    /// Optional snapshot image of the complete outfit
    /// Stored as Data (JPEG) for SwiftData compatibility
    var imageData: Data?
    
    // MARK: - Initializers
    
    /// Designated initializer for creating an outfit
    /// - Parameters:
    ///   - name: Display name for the outfit
    ///   - items: Array of clothing items (can be empty initially)
    ///   - dateCreated: Creation date (defaults to now)
    ///   - imageData: Optional outfit preview image
    init(
        name: String,
        items: [ClothingItem] = [],
        dateCreated: Date = Date(),
        imageData: Data? = nil
    ) {
        self.name = name
        self.items = items
        self.dateCreated = dateCreated
        self.imageData = imageData
    }
}

// MARK: - Convenience Extensions

extension Outfit {
    /// Convenience computed property to get UIImage from imageData
    /// Similar pattern to ClothingItem - bridges SwiftData storage to SwiftUI-friendly types
    @Transient
    var image: UIImage? {
        get {
            guard let imageData else { return nil }
            return UIImage(data: imageData)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.9)
        }
    }
}

