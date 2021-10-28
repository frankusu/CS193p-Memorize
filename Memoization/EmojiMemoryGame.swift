//
//  EmojiMemoryGame.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-28.
//

import SwiftUI
// this is the ViewModel
// be the intermediary between the model and the view

class EmojiMemoryGame {
    
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]
    
    // don't need to include EmojiMemoryGame.emojis or EmojiMemoryGame.createMemoryGame() if its during initialization ie: "=" or if its in another static as well
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // ViewModel = Gatekeeper; protect model from ill-behaving views
    // original version: private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 4, createCardContent: { (index: Int) -> String in return "😃"}) which can be reduced to code below since MemoryGame already knows what type of function it takes
    private var model: MemoryGame<String> = createMemoryGame()
    
    
    // instead of private(set) var model we can make our own var cards
    // the cards in the model are structs. We copy structs thats why we ask the model for it's cards with the inline function
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
}
