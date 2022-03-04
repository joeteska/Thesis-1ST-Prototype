//
//  SwiftUIView.swift
//  Dolfin
//
//  Created by Josef Teska on 28.02.2022.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var animate = false
    
    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
        
         ScrollView {
             LazyVGrid(columns: columns) {
                 ForEach((0...200), id: \.self) {
                     let codepoint = $0 + 0x1f600
                     let emoji = String(Character(UnicodeScalar(codepoint)!))
                     Text("\(emoji)")
                         .font(.system(size: 50))
                         
             }.font(.largeTitle)
         }
         }
        
        /*
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      
            .scaleEffect(animate ? 5 : 1)
            .offset(y: animate ? 250 : 0)
            .animation(Animation.easeIn(duration: 5).delay(1))
            .onAppear{
                animate = true
            }
         */
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
