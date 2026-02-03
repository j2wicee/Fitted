//
//  WardrobeGridView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/29/26.
//

import SwiftUI
struct WardrobeGridView: View {
    @EnvironmentObject var wardrobe: Wardrobe
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 12)
    ]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 12){
                ForEach($wardrobe.items) { $item in
                    NavigationLink{
                        ClothingDetailView(item: $item)
                    } label:{
                        ClothingTile(item: item)
                    }
                }
            }
            .padding()
            .navigationTitle("Wardrobe")
        }
    }
}
