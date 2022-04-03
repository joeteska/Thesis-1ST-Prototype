//
//  Settings.swift
//  Dolfin
//
//  Created by Josef Teska on 27.02.2022.
//

import SwiftUI


struct Settings: View {
    
    let currency = ["USD","EUR","GBP","JPY","MXN"]
    let emoji = ["🇺🇸","🇪🇺","🇬🇧"]
    @State private var date = Date()

    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("currency") var currencySign = "USD"

    var body: some View {
            
    

                    
        ZStack{
            
            Color(isDarkMode == true ? .black : .white) .edgesIgnoringSafeArea(.all)

            
            VStack(alignment: .leading){
                
                Text("Settings")
                .foregroundColor(isDarkMode == true ? .white: .black)
                .font(Font.custom("Poppins", size: 30))
                .padding(.horizontal, 40)
                .padding(.top, 70)


                Spacer()
                    .frame(height: 40)
                
                               
                Text("Currency")
                .padding(.horizontal, 40)
                .foregroundColor(isDarkMode == true ? .white: .black)

                .font(Font.custom("Poppins", size: 15))

            
            ScrollView(.horizontal, showsIndicators: false){
                
                HStack{
                    ForEach(currency, id: \.self) { currency in
                        Spacer()
                        Button {
                            currencySign = currency
                        } label: {
                            ZStack{
                                
                                Button {
                                    currencySign = currency
                                } label: {
                                    
                                    VStack {
                                        
                                    
                                    Text(currency)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)
                                        .opacity(0.4)
                                        .font(Font.custom("Poppins", size: 30))
                                        .padding(.horizontal, 3)
                                    }
                                }
                            
                        if  currencySign == currency {
                           
                            Text(currency)
                                .fontWeight(.bold)
                                .foregroundColor(isDarkMode == true ? .white: .black)
                                .font(Font.custom("Poppins", size: 30))

                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 60, height: 2)
                                .foregroundColor(isDarkMode == true ? .white: .black)
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
                .foregroundColor(isDarkMode == true ? .white: .black)
                .font(Font.custom("Poppins", size: 25))
                
                Toggle("", isOn: $isDarkMode)
                    .padding(.horizontal, 50)
                    .labelsHidden()
                    
                    
            }
                
                Divider()
                    .padding()
                
               
                Spacer().frame(height: 150)

                
                
                VStack(alignment:.center){
                Text("Created by Dolfin")
                        .font(.headline)
                        .font(.system(size: 20))
                    Spacer().frame(height: 20)

                Text("Contact us with further enquiries")
                        .font(.system(size: 10))

                    Spacer().frame(height: 5)

                    
                Text("We do not process any data.")
                        .font(.system(size: 10))

                    Spacer().frame(height: 5)
                    

                    
                Text("All data is stored locally on your device.")
                .multilineTextAlignment(.center)
                .font(.system(size: 10))

                    Spacer().frame(height: 20)

                    HStack {
                    VStack(alignment:.center){
                        
                        Link(destination: URL(string: "mailto:techdevil10@gmail.com")!) {
                    VStack {
                            Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                        Spacer().frame(height: 10)
                            Text("Contact")
                            .font(.system(size: 10))

                        }
                    .foregroundColor(isDarkMode == true ? .white: .gray)
                    }
                   
                    }
                
                        Spacer().frame(width: 30)

                        
                        VStack(alignment:.center){
                            
                            Link(destination: URL(string: "http://www.dolfinapp.xyz")!) {
                        VStack {
                                Image(systemName: "network")
                                .font(.system(size: 20))
                            Spacer().frame(height: 10)
                                Text("Website")
                                .font(.system(size: 10))

                            }
                        .foregroundColor(isDarkMode == true ? .white: .gray)
                        }
                            
                            
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundColor(isDarkMode == true ? .white: .gray)
                .frame(width: 300)
                .padding(.horizontal, 40)
                .opacity(0.3)


               
                Spacer()

                
            }
        }
        
        .background(isDarkMode == true ? .black: .white)


    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
