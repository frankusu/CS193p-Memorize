//
//  MemoizationApp.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-26.
//

import SwiftUI

@main
struct MemoizationApp: App {
    // free init that classes get
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
