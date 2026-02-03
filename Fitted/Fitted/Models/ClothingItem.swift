//
//  ClothingItem.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//


import SwiftUI
import SwiftData
import UIKit

@Model
class ClothingItem {
    // Persisted properties
    var name: String
    var type: ClothingType
    var size: ClothingSize
    var colorHex: String
    var imageData: Data?

    // Convenience, non‑persisted properties that bridge to the stored values
    @Transient
    var color: Color {
        get {
            Color(hex: colorHex) ?? .gray
        }
        set {
            colorHex = newValue.toHex() ?? "#808080"
        }
    }

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

    // Designated initializer used by SwiftData
    init(
        name: String,
        type: ClothingType,
        size: ClothingSize,
        colorHex: String,
        imageData: Data? = nil
    ) {
        self.name = name
        self.type = type
        self.size = size
        self.colorHex = colorHex
        self.imageData = imageData
    }

    // Convenience initializer for use in views so you can work with Color / UIImage
    convenience init(
        name: String,
        type: ClothingType,
        size: ClothingSize,
        color: Color,
        image: UIImage? = nil
    ) {
        let hex = color.toHex() ?? "#808080"
        let data = image?.jpegData(compressionQuality: 0.9)
        self.init(name: name, type: type, size: size, colorHex: hex, imageData: data)
    }
}

enum ClothingType: String, CaseIterable, Codable, Identifiable {
    case shirt = "Shirt"
    case pants = "Pants"
    case dress = "Dress"
    case skirt = "Skirt"
    case jacket = "Jacket"
    case sweater = "Sweater"
    case shorts = "Shorts"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case other = "Other"

    var id: String { rawValue }
}

enum ClothingSize: String, CaseIterable, Codable, Identifiable {
    case xxs = "XXS"
    case xs = "XS"
    case s = "S"
    case m = "M"
    case l = "L"
    case xl = "XL"
    case xxl = "XXL"
    case xxxl = "XXXL"
    case notApplicable = "N/A"

    var id: String { rawValue }
}

// MARK: - Color / UIColor helpers for hex <-> Color bridging

extension Color {
    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self = Color(uiColor)
    }

    /// Returns a hex string in the form `#RRGGBB`
    func toHex() -> String? {
        UIColor(self).toHex()
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if string.hasPrefix("#") {
            string.removeFirst()
        }

        guard string.count == 6,
              let rgb = Int(string, radix: 16) else {
            return nil
        }

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let rgb = (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
        return String(format: "#%06X", rgb)
    }
}

