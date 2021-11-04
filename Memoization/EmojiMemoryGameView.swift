//
//  EmojiMemoryGameView.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-26.
//

import SwiftUI
// this is the View
struct EmojiMemoryGameView: View {
    // everytime this changes please redraw me. has to be a var
    // var game is the viewModel
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    // just initialize it to vehicles for now
    @State var currentEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]
    
    let vehicleEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]

    let foodEmojis = ["🍏", "🍌", "🍈", "🥥", "🥦", "🌽", "🥔", "🥖", "🧈", "🍗", "🍎", "🍉", "🍒", "🥝", "🥬", "🍠", "🥨", "🥞", "🍖", "🍐", "🍇", "🍑", "🍅",] //24

    let heartEmojis = ["❤️", "💜", "❤️‍🔥", "💓", "🧡", "🖤", "❤️‍🩹", "💗", "💛", "❣️", "💖", "💚", "🤎", "💕", "💘", "💙", "💔", "💞", "💝",] //19
    
    var body: some View {
        ZStack(alignment: .bottom) { // so when the deck disappears it won't leave space for where the deck used to be
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
            }
            deckBody
        }
        
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    // make cards deal from the top of the deck
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0 )
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            // before the AspectVGrid is finished appearing, if the cards are not yet in the dealt, we add it after. Hence it will change from Color.clear to adding the card and will then run the .asymetric(insertion: . scale
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
//                Rectangle().opacity(0)
                Color.clear
            } else {
                CardView(card: card)
                //                    .aspectRatio(2/3, contentMode: .fit)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) // linked to deck body
                    .padding(4)
                // type erased?
//                    .transition(AnyTransition.scale.animation(.easeInOut(duration: 2))) // zooms out until it disappears
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale)) // when appear do nothing, when remove .scale
                    .zIndex(zIndex(of: card)) // higher number will be in the front, smaller would be in the back
                    .onTapGesture {
                        // user intent to flip cards
                        withAnimation(.easeInOut(duration: 1)) {
                            game.choose(card)
                        }
                        
                    }
            }
        }
        // aspectVGrid needs to appear first then we get the cards on so then the .transition animation will run when appear
//        .onAppear(perform: {
//            // "deal" cards
//            withAnimation(.easeInOut(duration: 5)) {
//                for card in game.cards {
//                    deal(card)
//                }
//            }
//        })
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
//            ForEach(game.cards.filter({ isUndealt($0)})) { card in
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace) // linked to game body
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        //fixed size since we don't need deck to change size
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        // aspectVGrid needs to appear first then we get the cards on so then the .transition animation will run when appear
        .onTapGesture {
            // "deal" cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            // we use explicit animation for call to intent functions
            withAnimation(.easeInOut(duration: 1)) {
                game.shuffle()
            }
            
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
//    var emoji: String
    let card: EmojiMemoryGame.Card
    
    // want to animate to the future since we want to count down to zero.
    // but since theres nothing chaning in the view the pie won't move. Thats why we animate to the future ( value )
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        // we use geometry reader to calculate better font size for emoji in card
        GeometryReader(content: { geometry in
//            ZStack {
//                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
//                if card.isFaceUp {
//                    shape.fill().foregroundColor(.white)
//                    // strokeBorder is inside of card so it won't look cut off by scrollView
//                    shape.strokeBorder(lineWidth: 3)
////                    Circle().padding(5).opacity(0.5)
//                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
//                        .padding(5).opacity(0.5)
//                    Text(card.content).font(font(in: geometry.size))
//                } else if card.isMatched {
//                    shape.opacity(0)
//                } else {
//                    shape.fill()
//                }
//            }
            // using cardify simplifies the Zstack into this
            ZStack {
//                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
//                    .padding(5).opacity(0.5)
                Group {
                    if card.isConsumingBonusTime {
                        // everytime this pie appears we wil start from card.bonusRemaining and animate to wards 0 
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                // implicit animation rarely used
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    //.font(font(in: geometry.size)) dynamic font is not animatable so need to set it to a fixed value
                // if we don't do this, when we switch app to landscape mode, the emoji's would float to the card
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
        
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
//    private func font(in size: CGSize) -> Font {
//        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
//    }
    
    private struct DrawingConstants {
        // in cardify
//        static let cornerRadius: CGFloat = 10
//        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        // to flip up first card in preview without having to flip all the other cards 
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            // dark mode
//            .preferredColorScheme(.dark)
    }
}
