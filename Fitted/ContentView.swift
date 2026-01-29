//
//  ContentView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//

import SwiftUI

struct ContentView: View {
    @State private var wardrobe = Wardrobe()
    @State private var showingAddItem = false
    
    
    var body: some View {
        NavigationStack{
            WardrobeGridView()
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button(action: {showingAddItem = true}){
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddItem){
                    AddItemView()
                        .environmentObject(wardrobe)
                }
        }
        .environmentObject(wardrobe)
    }
}

#Preview {
    ContentView()
}
