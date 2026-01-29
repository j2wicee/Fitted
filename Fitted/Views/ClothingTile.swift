//
//  ClothingTile.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/29/26.
//
import SwiftUI
struct ClothingTile: View {
    let item : ClothingItem
    var body: some View {
        VStack{
            if let img = item.image{
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(8)
            } else{
                Image(systemName: "tshirt")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.gray)
            }
            Text(item.name)
                .font(.headline)
        }
        .padding(4)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

