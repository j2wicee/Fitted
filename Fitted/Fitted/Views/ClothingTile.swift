import Foundation
import SwiftUI

struct ClothingTile: View {
    let item: ClothingItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                if let img = item.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .clipped()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.secondarySystemBackground))

                        Image(systemName: "tshirt")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 110)
                }

                // Subtle gradient at the bottom to help text, if needed later
                LinearGradient(
                    colors: [.black.opacity(0.0), .black.opacity(0.20)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: 40)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(item.type.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
}
