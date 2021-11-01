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
    
    // just initialize it to vehicles for now
    @State var currentEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]
    
    let vehicleEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]

    let foodEmojis = ["🍏", "🍌", "🍈", "🥥", "🥦", "🌽", "🥔", "🥖", "🧈", "🍗", "🍎", "🍉", "🍒", "🥝", "🥬", "🍠", "🥨", "🥞", "🍖", "🍐", "🍇", "🍑", "🍅",] //24

    let heartEmojis = ["❤️", "💜", "❤️‍🔥", "💓", "🧡", "🖤", "❤️‍🩹", "💗", "💛", "❣️", "💖", "💚", "🤎", "💕", "💘", "💙", "💔", "💞", "💝",] //19
    
    var body: some View {

        VStack {
            Text("Memorize!")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                // user intent to flip cards
                                game.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
//            Spacer()
//            HStack {
//                Spacer()
//                vehicleThemeButton
//                Spacer()
//                foodThemeButton
//                Spacer()
//                heartThemeButton
//                Spacer()
//            }
//            .font(.largeTitle)
//            .padding(.horizontal)
        }
        .padding(.horizontal)
        
        
    }
    
    // systemName from SFSymbol
    // mouth for Food
    // car for Vehicle
    // heart for Heart
    
    var vehicleThemeButton: some View {
        Button {
            // change the theme
            print("vehicle pressed")
//            emojiCount = Int.random(in: 8...vehicleEmojis.count)
            currentEmojis = vehicleEmojis
        } label: {
            VStack {
                Image(systemName: "car")
                Text("Vehicles")
                    .font(.body)
            }
        }
    }
    
    var foodThemeButton: some View {
        Button {
            print("food pressed")
//            emojiCount = Int.random(in: 8...foodEmojis.count)
            currentEmojis = foodEmojis
        } label: {
            VStack {
                Image(systemName: "mouth")
                Text("Food")
                    .font(.body)
            }
        }
    }
    
    var heartThemeButton: some View {
        Button {
            print("heart pressed")
//            emojiCount = Int.random(in: 8...heartEmojis.count)
            currentEmojis = heartEmojis
        } label: {
            VStack {
                Image(systemName: "heart")
                Text("Hearts")
                    .font(.body)
            }
        }
    }

}

struct CardView: View {
//    var emoji: String
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        // we use geometry reader to calculate better font size for emoji in card
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    // strokeBorder is inside of card so it won't look cut off by scrollView
                    shape.strokeBorder(lineWidth: 3)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        })
        
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            // dark mode
//            .preferredColorScheme(.dark)
    }
}
