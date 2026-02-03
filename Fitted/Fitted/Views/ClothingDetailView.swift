//
//  ClothingDetailView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 2/2/26.
//

import Foundation
import SwiftUI

struct ClothingDetailView: View {
    @Binding var item: ClothingItem

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image header with subtle background and overlay
                if let img = item.image {
                    ZStack(alignment: .bottomLeading) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 320)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)

                        // Title over image for a premium look
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.title2).bold()
                                .foregroundStyle(.white)
                                .shadow(radius: 2)

                            HStack(spacing: 8) {
                                // Type chip
                                Text(item.type.rawValue)
                                    .font(.subheadline)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .foregroundStyle(.white)

                                // Size chip
                                Text(
                                    item.size == .notApplicable ? "Size: N/A" : "Size: \(item.size.rawValue)"
                                )
                                .font(.subheadline)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(.ultraThinMaterial, in: Capsule())
                                .foregroundStyle(.white)
                            }
                        }
                        .padding(16)
                    }
                }

                // Details card
                VStack(alignment: .leading, spacing: 14) {
                    // Title and meta again for when there is no image
                    if item.image == nil {
                        Text(item.name)
                            .font(.largeTitle).bold()

                        HStack(spacing: 8) {
                            Label(item.type.rawValue, systemImage: "tag")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Divider()
                                .frame(height: 14)

                            Text(item.size == .notApplicable ? "Size: N/A" : "Size: \(item.size.rawValue)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Color preview row
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(item.color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Color")
                                .font(.headline)
                            Text("This item’s primary color")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    // Type and size rows
                    VStack(spacing: 10) {
                        HStack {
                            Label("Type", systemImage: "tshirt")
                                .font(.headline)
                            Spacer()
                            Text(item.type.rawValue)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)

                        Divider()

                        HStack {
                            Label("Size", systemImage: "ruler")
                                .font(.headline)
                            Spacer()
                            Text(item.size == .notApplicable ? "N/A" : item.size.rawValue)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                )
            }
            .padding()
        }
        .navigationTitle("Item")
        .toolbar {
            Button("Edit") {
                isEditing = true
            }
        }
        .sheet(isPresented: $isEditing) {
            EditClothingView(item: $item)
        }
    }
}
