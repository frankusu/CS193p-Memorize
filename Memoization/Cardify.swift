//
//  Cardify.swift
//  Memoization
//
//  Created by Frank Su on 2021-11-02.
//

import SwiftUI

// we use ViewModifiers so can use animation on it
// also we can 'Cardify' any view
struct Cardify: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                // content is what we 'cardify' which is the Pie and text from View
                // since implicit animations only work on things that are already on the screen, and content is only on the screen for isFaceUp, that means the animation wouldn't appy to it the moment it appears.
//                content
            } else {
                shape.fill()
            }
            // hence we need to use a hack to set the opacity based on if is faced up for the second card that matched to spin as well
            content.opacity(isFaceUp ? 1 : 0)
            
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
    
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
