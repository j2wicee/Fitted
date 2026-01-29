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
    var type: String
    var color: Color
    var size: String?
    var image: UIImage?
    
    
}

