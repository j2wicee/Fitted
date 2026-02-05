//
//  OutfitTile.swift
//  Fitted
//
//  Created by Joshua  Evans  on 2/5/26.
//

import Foundation
import SwiftData
import SwiftUI

struct OutfitTile: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            GeometryReader { geometry in
                collageView(width: geometry.size.width)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(outfit.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(outfit.items.count) item\(outfit.items.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 2)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
    
    @ViewBuilder
    private func collageView(width: CGFloat) -> some View {
        VStack(spacing: 4) {
            
            // Hero image (top 62%)
            if let heroImage = heroClothingImage {
                Image(uiImage: heroImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width * 0.62)  // BUG FIX: Added 0. prefix
                    .clipped()
                    .background(Color(.secondarySystemBackground))
            } else {
                placeholderView(width: width, height: width * 0.62, iconSize: 32)
            }
            
            // Supporting images in bottom row
            HStack(spacing: 4) {
                // First supporting image
                if let supportImage1 = supportingClothingImages.first {
                    Image(uiImage: supportImage1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (width - 4) / 2, height: width * 0.34)  // BUG FIX: Added 0. prefix
                        .clipped()
                        .background(Color(.tertiarySystemBackground))
                } else {
                    placeholderView(width: (width - 4) / 2, height: width * 0.34, iconSize: 20)
                }
                
                // BUG FIX: Added second supporting image (was missing!)
                // Second supporting image
                if supportingClothingImages.count > 1, let supportImage2 = supportingClothingImages[safe: 1] {
                    Image(uiImage: supportImage2)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (width - 4) / 2, height: width * 0.34)
                        .clipped()
                        .background(Color(.tertiarySystemBackground))
                } else {
                    placeholderView(width: (width - 4) / 2, height: width * 0.34, iconSize: 20)
                }
            }
        }
    }
    
    private func placeholderView(width: CGFloat, height: CGFloat, iconSize: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.tertiarySystemBackground))
            
            Image(systemName: "photo")  // BUG FIX: Was "Photo" (uppercase P doesn't exist)
                .font(.system(size: iconSize))
                .foregroundStyle(.quaternary)
        }
        .frame(width: width, height: height)
    }
    
    
    private var heroClothingImage: UIImage? {
        // Priority 1: Upper body items (most visually representative)
        if let topItem = outfit.items.first(where: {
            $0.type == .shirt || $0.type == .sweater || $0.type == .jacket
        }), let image = topItem.image {
            return image
        }
        
        // Priority 2: Dresses (complete outfit)
        if let dressItem = outfit.items.first(where: { $0.type == .dress }),
           let image = dressItem.image {
            return image
        }
        
        // Priority 3: Any item with an image
        return outfit.items.first(where: { $0.image != nil })?.image
    }
    
    
    private var supportingClothingImages: [UIImage] {
        var images: [UIImage] = []
        
        // Get the hero item to exclude it
        let heroItem = outfit.items.first(where: { $0.image == heroClothingImage })
        
        // Priority 1: Bottoms (pants, skirt, shorts, dress)
        if let bottomItem = outfit.items.first(where: {
            ($0.type == .pants || $0.type == .skirt || $0.type == .shorts) &&
            $0.id != heroItem?.id
        }), let image = bottomItem.image {
            images.append(image)
        }
        
        // Priority 2: Shoes
        if let shoesItem = outfit.items.first(where: {
            $0.type == .shoes && $0.id != heroItem?.id
        }), let image = shoesItem.image {
            // Only add if we haven't already added this exact image
            if !images.contains(where: { $0 == image }) {
                images.append(image)
            }
        }
        
        // Fill remaining slots with any other items (jacket, accessories, etc.)
        if images.count < 2 {
            let remainingItems = outfit.items
                .filter { $0.id != heroItem?.id && $0.image != nil }
                .filter { item in !images.contains(where: { $0 == item.image }) }
            
            for item in remainingItems {
                if images.count >= 2 { break }
                if let image = item.image {
                    images.append(image)
                }
            }
        }
        
        return images
    }
}

// BUG FIX: Array extension must be OUTSIDE the struct
// MARK: - Array Extension

/// Safe array subscripting to prevent crashes when accessing out-of-bounds indices
/// Performance note: This is a simple bounds check with no overhead for valid indices
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
