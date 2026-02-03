//
//  WardrobeGridView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/29/26.
//

import SwiftUI
import SwiftData
struct WardrobeGridView: View {
    @Query var items: [ClothingItem]
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 12)
    ]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 12){
                ForEach(items) { item in
                    NavigationLink{
                        ClothingDetailView(item: item)
                    } label:{
                        ClothingTile(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .navigationTitle("Wardrobe")
        }
    }
}
