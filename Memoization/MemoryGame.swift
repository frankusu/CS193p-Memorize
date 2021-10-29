//
//  MemoryGame.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-28.
//

import Foundation
// this is the Model
// Binary operator '==' cannot be applied to two 'CardContent' operands
// so we need to make the "Don't Care" generic into a Equatable using 'where'
struct MemoryGame<CardContent> where CardContent: Equatable {
    // you can look at these but you cannot touch them.
    // only the model should be able to change cards
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    // its mutating because we changing the card array
    mutating func choose(_ card: Card) {
//        if let chosenIndex = cards.firstIndex(where: { aCardInTheCardsArray in aCardInTheCardsArray.id == card.id }) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    // if no match then flip all the cards facedown
                    cards[index].isFaceUp = false
                }
                // and keep the one you just tapped to the chosenIndex
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            // this assign property copies the card. so you have to change the card it self from the cards array
    //        var chosenCard = cards[chosenIndex]
            cards[chosenIndex].isFaceUp.toggle()
        }
        print("\(cards)")
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
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}
