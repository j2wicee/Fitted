//
//  FittedApp.swift
//  Fitted
//
//  Created by Joshua  Evans  on 1/28/26.
//

import SwiftUI
import SwiftData

@main
struct FittedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ClothingItem.self])
    }
}
