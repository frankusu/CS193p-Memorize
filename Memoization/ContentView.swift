//
//  ContentView.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-26.
//

import SwiftUI
// this is the View
struct ContentView: View {
    let viewModel: EmojiMemoryGame
    
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
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                // user intent to flip cards
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                Spacer()
                vehicleThemeButton
                Spacer()
                foodThemeButton
                Spacer()
                heartThemeButton
                Spacer()
            }
            .font(.largeTitle)
            .padding(.horizontal)
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
    let card: MemoryGame<String>.Card
    
    var body: some View {
        
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                // strokeBorder is inside of card so it won't look cut off by scrollView
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            // dark mode
//            .preferredColorScheme(.dark)
    }
}
