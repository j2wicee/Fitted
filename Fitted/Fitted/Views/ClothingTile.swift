import Foundation
import SwiftUI

struct ClothingTile: View {
    let item: ClothingItem

    var body: some View {
        VStack(spacing: 8) {
            if let img = item.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .cornerRadius(8)
            } else {
                Image(systemName: "tshirt")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .foregroundColor(.gray)
            }

            Text(item.name)
                .font(.headline)

            Text(item.type.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(6)
        .cornerRadius(10)
    }
}
