//
//  Settings.swift
//  Dolfin
//
//  Created by Josef Teska on 27.02.2022.
//

import SwiftUI

struct Settings: View {
    
    let currency = ["🇺🇸 USD",
                    "🇪🇺 EUR",
                    "🇬🇧 GBP",
                    "🇨🇿 CZK",
                    "🇲🇽 MXN",
                    "🇨🇳 CNY",
                    "🇮🇳 RUP"]
    

    
    @State var userCurrency: String = "🇺🇸 USD"
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        NavigationView{
            
        VStack(alignment: .leading){
           
            Text("Currency")
            .padding(.horizontal, 40)
            .font(Font.custom("Poppins", size: 15))

        
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack{
                ForEach(currency, id: \.self) { currency in
                    Spacer()
                    Button {
                        userCurrency = currency
                    } label: {
                        ZStack{
                
                        Text(currency)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .opacity(0.4)
                            .font(Font.custom("Poppins", size: 30))
                            .padding(.horizontal, 3)

                        
                    if userCurrency == currency {
                        Text(currency)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white: .black)
                            .font(Font.custom("Poppins", size: 30))

                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 2)
                            .foregroundColor(colorScheme == .dark ? .white: .black)
                            .offset(y:20)
                        
                            
                                    }
                                }
                        .frame(height: 50)
        
                            }
                        }
                    }
            .padding(.horizontal, 30)

                }
            
            Divider()
                .padding()
        HStack{
            
            Text("Dark Mode")
            .padding(.horizontal, 40)
            .font(Font.custom("Poppins", size: 25))
            
            Toggle("", isOn: $isDarkMode)
                .toggleStyle(SwitchToggleStyle(tint: .black))
                .padding(.horizontal, 50)
                .labelsHidden()
                
                
        }
            Divider()
                .padding()

            }
        }
        .navigationBarItems(trailing: EditButton())

    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
