//
//  Wardrobe.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//
import SwiftUI
import Combine

class Wardrobe : ObservableObject {
    
    @Published var items : [ClothingItem] = []
    
    func addItem(_ item: ClothingItem){
        items.append(item)
    }
    
    func remove(itemID: UUID){
        items.removeAll{ $0.id == itemID }
    }
}
