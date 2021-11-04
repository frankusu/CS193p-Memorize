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
            
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        //            var faceUpCardIndices = [Int]()
        //            for index in cards.indices {
        //                if cards[index].isFaceUp {
        //                    faceUpCardIndices.append(index)
        //                }
        //            }
        //            if faceUpCardIndices.count == 1 {
        //                return faceUpCardIndices.first
        //            } else {
        //                return nil
        //            }
        
        // power of functional programming
        // can take away () in ({cards[] ...}) but its 'the art of programming
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
//        set { cards.indices.forEach( { index in cards[index].isFaceUp = (index == newValue) }) }
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    
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
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
        print("\(cards)")
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // we need this initializer because we don't want ViewModel to create the cards, that wouldn't make sense. We need The model to create the cards so ViewModel can just pass in the # of cards
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2)) // 0 2 4 6
            cards.append(Card(content: content, id: pairIndex*2+1)) // 1 3 5
        }
        cards.shuffle()
    }
    
    // this is actually MemoryGame.Card
    // why namespace this? make sure this is a Card in MemoryGame and not poker
    struct Card: Identifiable {
//        var id: ObjectIdentifier //this is really a "don't care"
        
        // property observer
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user mathces the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

// extension var has to be computed cannot be stored in memory
extension Array {
    var oneAndOnly: Element? {
        // oneAndOnly is itself an array so can just omit the self keyword
//        if self.count == 1 {
//            return self.first
//        }
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}

