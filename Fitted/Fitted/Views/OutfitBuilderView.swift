//
//  OutfitBuilderView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//

import SwiftUI
import SwiftData


/// View for building a new outfit by selecting clothing items
///
/// **State Management Architecture:**
/// - Uses @State for local UI state (selected items, outfit name)
/// - Uses @Environment(\.modelContext) to save to SwiftData
/// - Uses @Query to fetch all clothing items
/// - Selection is managed with a Set<ObjectIdentifier> for O(1) lookup performance
struct OutfitBuilderView: View {
    // MARK: - SwiftData Environment
    
    /// Access to SwiftData's persistence context
    /// We'll use this to insert the new outfit when saving
    @Environment(\.modelContext) private var modelContext
    
    /// Dismiss handler to close this view (passed from parent)
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Data Query
    
    /// Fetch all clothing items from SwiftData
    /// @Query automatically updates when items are added/deleted elsewhere
    @Query private var allItems: [ClothingItem]
    
    // MARK: - Local State
    
    /// The name the user gives to this outfit
    /// Starts empty, user must fill it in before saving
    @State private var outfitName: String = ""
    
    /// Set of selected item object identifiers
    /// **Why Set instead of Array?**
    /// - O(1) lookup for "is this item selected?" checks
    /// - Automatically prevents duplicates
    /// - Easy to toggle: if contains, remove; else add
    /// **Why ObjectIdentifier?**
    /// - SwiftData models are classes (reference types)
    /// - ObjectIdentifier gives us a stable, unique ID for each instance
    /// - Works reliably across SwiftData's persistence layer
    @State private var selectedItemIDs: Set<ObjectIdentifier> = []
    
    // MARK: - Computed Properties
    
    /// Get the actual ClothingItem objects from selected IDs
    /// This filters allItems to only those whose ObjectIdentifier matches our selected IDs
    private var selectedItems: [ClothingItem] {
        allItems.filter { item in
            selectedItemIDs.contains(ObjectIdentifier(item))
        }
    }
    
    /// Can we save this outfit?
    /// Requires: at least one item selected AND a non-empty name
    private var canSave: Bool {
        !outfitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedItems.isEmpty
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top section: Outfit name input
                nameInputSection
                
                Divider()
                
                // Middle section: Selected items preview
                if !selectedItems.isEmpty {
                    selectedItemsSection
                    Divider()
                }
                
                // Bottom section: All items grid for selection
                itemsGridSection
            }
            .navigationTitle("New Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveOutfit()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
    
    // MARK: - View Components
    
    /// Text field for entering outfit name
    private var nameInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outfit Name")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            TextField("e.g., Casual Friday, Date Night", text: $outfitName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    /// Horizontal scrollable list of selected items
    /// Shows what the user has picked so far
    private var selectedItemsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Selected Items (\(selectedItems.count))")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(selectedItems) { item in
                        SelectedItemCard(item: item) {
                            // Toggle selection: tap to deselect
                            toggleSelection(for: item)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color(.secondarySystemBackground))
    }
    
    /// Grid of all clothing items for selection
    private var itemsGridSection: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 110), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(allItems) { item in
                    SelectableClothingTile(
                        item: item,
                        isSelected: selectedItemIDs.contains(ObjectIdentifier(item))
                    ) {
                        // Toggle selection when tapped
                        toggleSelection(for: item)
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Actions
    
    /// Toggle an item's selection state
    /// **How it works:**
    /// 1. Get the item's ObjectIdentifier (unique identifier for the instance)
    /// 2. If it's in the Set, remove it (deselect)
    /// 3. If it's not in the Set, add it (select)
    private func toggleSelection(for item: ClothingItem) {
        let id = ObjectIdentifier(item)
        if selectedItemIDs.contains(id) {
            selectedItemIDs.remove(id)
        } else {
            selectedItemIDs.insert(id)
        }
    }
    
    /// Save the outfit to SwiftData
    /// **What happens:**
    /// 1. Create a new Outfit instance with the name and selected items
    /// 2. Insert it into the modelContext (SwiftData's persistence layer)
    /// 3. SwiftData automatically saves to disk
    /// 4. Dismiss this view to return to the previous screen
    private func saveOutfit() {
        let newOutfit = Outfit(
            name: outfitName.trimmingCharacters(in: .whitespacesAndNewlines),
            items: selectedItems,
            dateCreated: Date()
        )
        
        modelContext.insert(newOutfit)
        dismiss()
    }
}

// MARK: - Supporting Views

/// A card showing a selected item with a remove button
/// Used in the horizontal scroll at the top
private struct SelectedItemCard: View {
    let item: ClothingItem
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            // Item image or placeholder
            Group {
                if let img = item.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "tshirt")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                // X button to remove
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .offset(x: 4, y: -4),
                alignment: .topTrailing
            )
            
            Text(item.name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 60)
        }
    }
}

/// A clothing tile that shows selection state
/// Visual feedback: selected items have a border/overlay
private struct SelectableClothingTile: View {
    let item: ClothingItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ClothingTile(item: item)
                .overlay(
                    // Selection indicator
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.accentColor : Color.clear,
                            lineWidth: 3
                        )
                )
                .overlay(
                    // Checkmark for selected items
                    Group {
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .font(.title3)
                        }
                    }
                    .padding(8),
                    alignment: .topTrailing
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OutfitBuilderView()
        .modelContainer(for: [ClothingItem.self, Outfit.self], inMemory: true)
}
