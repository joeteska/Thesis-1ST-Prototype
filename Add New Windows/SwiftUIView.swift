//
//  SwiftUIView.swift
//  Dolfin
//
//  Created by Josef Teska on 28.02.2022.
//

import SwiftUI

struct SwiftUIView: View {
  
    @AppStorage("emoji") var emojiSelected = "😄"
    @State var animate = false
    @State var showSheetView = false
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var colorSelection: String = "blue"


    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]

    
    var body: some View {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
        
        NavigationView{
            
            VStack{
                Text("\(emojiSelected)")
                    .font(.system(size: 120))
        
                ScrollView(.vertical, showsIndicators: true) {
             LazyVGrid(columns: columns) {
                 ForEach((0...70), id: \.self) {
                     let codepoint = $0 + 0x1f600
                     let emoji = String(Character(UnicodeScalar(codepoint)!))
                     Text("\(emoji)")
                         .font(.system(size: 50))
                         .onTapGesture {
                         emojiSelected = emoji
                                                }
                     
                         
                        }.font(.largeTitle)
                    }
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                
                self.presentationMode.wrappedValue.dismiss()

                
            }, label: {
                Text("save")
                    .foregroundColor(isDarkMode == true ? .white: Color(colorSelection))
            }))
            .navigationBarItems(leading:
                Button(action: {
                self.presentationMode.wrappedValue.dismiss()

            }, label: {
                Text("cancel")
                    .foregroundColor(isDarkMode == true ? .white: Color(colorSelection))


            }))
           
        }
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
