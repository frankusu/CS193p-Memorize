//
//  EmojiMemoryGame.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-28.
//

import SwiftUI
// this is the ViewModel
// be the intermediary between the model and the view

// ObservableObject can publish to the world something changed
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]
    
    // don't need to include EmojiMemoryGame.emojis or EmojiMemoryGame.createMemoryGame() if its during initialization ie: "=" or if its in another static as well
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // gets a var that we can't see that we get for free
    //var objectWillChange: ObservableObjectPublisher
    
    // ViewModel = Gatekeeper; protect model from ill-behaving views
    // original version: private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 4, createCardContent: { (index: Int) -> String in return "😃"}) which can be reduced to code below since MemoryGame already knows what type of function it takes
    // var here since the model: MemoryGame<String> has a mutating function called choose()
    // swift knows it changes cuz MemoryGame is a struct. It will not know with a class
    @Published private var model = createMemoryGame()
    
    
    // instead of private(set) var model we can make our own var cards
    // the cards in the model are structs. We copy structs thats why we ask the model for it's cards with the inline function
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        // tell the world that the object will change
//        objectWillChange.send() // don't even need this since we have @Published
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        // will change @Published private var model so will cause everything to redraw
        model = EmojiMemoryGame.createMemoryGame()
    }
}
