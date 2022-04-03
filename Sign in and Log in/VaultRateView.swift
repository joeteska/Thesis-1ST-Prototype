//
//  VaultRateView.swift
//  Dolfin
//
//  Created by Josef Teska on 07.03.2022.
//

import SwiftUI

struct VaultRateView: View {
    
    @Binding var rating: Int

    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        
        HStack {
  
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                }
            }
        }
    }
    
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
}

