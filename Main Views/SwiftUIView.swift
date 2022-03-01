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
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        /*
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
