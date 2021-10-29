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
    
    mutating func choose(_ card: Card) {
        let chosenIndex = index(of: card)
        // this assign property copies the card. so you have to change the card it self from the cards array
//        var chosenCard = cards[chosenIndex]
        cards[chosenIndex].isFaceUp.toggle()
        print("\(cards)")
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        return 0 // bogus!
    }
    
    // we need this initializer because we don't want ViewModel to create the cards, that wouldn't make sense. We need The model to create the cards so ViewModel can just pass in the # of cards
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2)) // 0 2 4 6
            cards.append(Card(content: content, id: pairIndex*2+1)) // 1 3 5
        }
    }
    
    // this is actually MemoryGame.Card
    // why namespace this? make sure this is a Card in MemoryGame and not poker
    struct Card: Identifiable {
//        var id: ObjectIdentifier //this is really a "don't care"
        
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}
