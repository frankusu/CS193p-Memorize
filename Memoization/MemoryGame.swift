//
//  MemoryGame.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-28.
//

import Foundation
// this is the Model
struct MemoryGame<CardContent> {
    // you can look at these but you cannot touch them.
    // only the model should be able to change cards
    private(set) var cards: [Card]
    
    func choose(_ card: Card) {
        // TODO: choose implementation
    }
    
    // we need this initializer because we don't want ViewModel to create the cards, that wouldn't make sense. We need The model to create the cards so ViewModel can just pass in the # of cards
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(constant: content))
            cards.append(Card(constant: content))
        }
    }
    
    // this is actually MemoryGame.Card
    // why namespace this? make sure this is a Card in MemoryGame and not poker
    struct Card {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var constant: CardContent
    }
}
