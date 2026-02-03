//
//  ClothingItem.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//


import SwiftUI
struct ClothingItem: Identifiable{
    let id = UUID()
    var name: String
    var type: ClothingType
    var color: Color
    var size: ClothingSize
    var image: UIImage?
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


