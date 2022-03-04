//
//  ContentView.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 29.12.2021.
//

import SwiftUI



struct ContentView: View {
    
    @State private var speed = 0.0
    @State private var isEditing = false
    @State private var myColor =  Color(red: 0.293, green: 0.771, blue: 1.006)
    
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
       
    
        
        TabView {
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                        .environment(\.symbolVariants, .none)
                        Text("Profile")

                    }
                      
            GoalsView()
                .tabItem {
                    Image(systemName: "bookmark")
                        .environment(\.symbolVariants, .none)

                            Text("Goals")
}
            TasksView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                        .environment(\.symbolVariants, .none)

                    Text("Tasks")
                }
            
            /*
            VaultsView()
                .tabItem {
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .environment(\.symbolVariants, .none)

                    Text("Vaults")
                }
            */
           
            
            
            }
        .accentColor(myColor)
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}




