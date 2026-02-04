//
//  WardrobeView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 2/4/26.
//

import Foundation
import SwiftUI
import SwiftData

struct WardrobeView: View {
    
    @Query var items: [ClothingItem]
    
    @State private var search: String = ""
    @State private var filterType : ClothingType? = nil
    @State private var showingAddItem = false
   
    
    var filteredItems: [ClothingItem] {
        items.filter{ item in
            (search.isEmpty || item.name.localizedCaseInsensitiveContains(search)) &&
            (filterType == nil || item.type == filterType)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(
                        label: "All",
                        isSelected: filterType == nil
                    ) {
                        filterType = nil
                    }

                    ForEach(ClothingType.allCases) { type in
                        FilterChip(
                            label: type.rawValue,
                            isSelected: filterType == type
                        ) {
                            filterType = type
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            WardrobeGridView(items: filteredItems)
        }
        .searchable(text: $search)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
        .navigationTitle("Wardrobe")
    }
}

// Simple pill-style filter button for the horizontal filter bar
private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.4), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
