//
//  ContentView.swift
//  Memoization
//
//  Created by Frank Su on 2021-10-26.
//

import SwiftUI

struct ContentView: View {
    @State private var emojiCount = 4
    
    let vehicleEmojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🏍", "🛺", "🚘", "🚝", "🚄", "🚈", "⛵️", "✈️", "🛳",]
    
    var body: some View {
        
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]){
                    ForEach(vehicleEmojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(emoji: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            Spacer()
            HStack {
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .foregroundColor(.red)
        
    }
    
    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    
    var add: some View {
        Button {
            if emojiCount < vehicleEmojis.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
}

struct CardView: View {
    var emoji: String
    @State private var isFaceUp = true
    
    var body: some View {
        
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 25)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                // strokeBorder is inside of card so it won't look cut off by scrollView
                shape.strokeBorder(lineWidth: 3)
                Text(emoji).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
        
    }
}























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            // dark mode
            .preferredColorScheme(.dark)
    }
}
