//
//  VaultsView.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 01.01.2022.
//


import SwiftUI
import CoreData
//import XCTest


struct VaultsView : View {
    
    @FetchRequest(
        entity: Vaults.entity(),
        sortDescriptors: [
         NSSortDescriptor(keyPath: \Vaults.date, ascending: false)
        ]
    ) var vaults: FetchedResults<Vaults>
    

    @State var myColor = Color(red: 0.997, green: 0.383, blue: 0.405) //tint color
    @State var addVault = false
    @State private var date = Date()
    @State var deleteItems = false
    @FocusState var isInputActive: Bool
    @State var ShowingAlert = false

    
    var items: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 2)

    
    var body: some View {
        NavigationView {
           
            VStack {

                if (vaults.isEmpty){
                    Text("🏦")
                        .font(.system(size: 60))
                        .opacity(0.5)
                    Spacer()
                        .frame(height: 10)
                    Text("No Active Vaults")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .opacity(0.3)
                    Text("Create a Vault by clicking the + button at the top of the screen")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .opacity(0.3)
                        .padding(.vertical, 1.0)
                        .padding(.horizontal, 80)
                        .lineSpacing(5)
                    
                    
                }
                
                else{
                    ScrollView(showsIndicators: false) {
                        Spacer().frame(height: 20)

                        LazyVGrid(columns: items){
                        ForEach(vaults, id: \.id) { vault in
                            
                            VaultListRowView(deleteItems: $deleteItems, vault: vault)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

            .navigationBarTitle(Text("Vaults 🏦"))
            .navigationBarItems(trailing:
            Button(action: {
                self.addVault.toggle()
            }, label: {
            Image(systemName: "plus")
            }))
            .navigationBarItems(trailing:
                Button(action: {
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                   impactMed.impactOccurred()
                deleteItems.toggle()
            }, label: {
                Text(deleteItems ? "Done" : "Edit")
            }))
            .accentColor(myColor)
        }
        
        .fullScreenCover(isPresented: $addVault) {
            AddVaultView(addVault: $addVault)
        }
        .font(Font.custom("Poppins", size: 15))
        
    }

}



struct AddVaultView: View {
    
    @Binding var addVault: Bool
    @State private var selectedColorIndex = 0
    @State var showSheetView = false
    @State private var isEditing = false
    @State var addVaultName: String = ""
    @State var splitAmount: String = ""
    @State var colorSelection: String = "blue"
    @State var addEmoji: String = "🏦"
    @State private var vaultBudget: String = ""
    @FocusState var isInputActive: Bool
    @State var vaultProgress: Double = 0.0
    @State var rating = 3
    @State private var disabled = true
    @State var animate = false
    @State private var selectedDate = Date()
    @State var showsDatePicker = false
    @State private var calendarId: Int = 0
    @State private var totalCost = ""
    @State var time = Timer.publish(every: 1.1, on: .current, in: .tracking).autoconnect()
    @State var show = false


    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]
    
    var body: some View {
        NavigationView{
            
        ZStack{
            
           
            ScrollView {
                
              
                GeometryReader{g in
                    
                    
                 
                    VStack(alignment: .center) {
                       
                        
                        
                        
                        ZStack(alignment: .center){
                            
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                            
                           

                        TextField("+", text: self.$addEmoji.max(1))

                            .font(.system(size: 35))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(colorSelection))

                            .focused($isInputActive)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()

                                    Button("Done") {
                                        isInputActive = false
                                    }
                                }
                            }
                            
                        }
                      
                           
                      /*  Button(action: {
                            self.showSheetView.toggle()
                        }) {
                            
                            Text("\(addEmoji)")
                                .font(.system(size: 35))
                                .multilineTextAlignment(.center)
                                .padding()
                           
                            
            }.fullScreenCover(isPresented: $showSheetView) {
            SwiftUIView(emojiSelected:addEmoji, colorSelection: colorSelection)
                        
            }*/
                             
                        

                       
                        Spacer()
                            .frame(height: 20)
                        
                        TextField("add name", text: self.$addVaultName.max(15))
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins", size: 30))
                            .frame(width: 300)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .focused($isInputActive)
                       
                    }
                    
                    .offset(y: g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY : 0)
                    .frame(height: g.frame(in: .global).minY > 0 ? UIScreen.main.bounds.height / 6 + g.frame(in: .global).minY  : UIScreen.main.bounds.height / 6)
                  
                    
                }
                .frame(height: UIScreen.main.bounds.height / 7)
     
                
                VStack {
                    Spacer().frame(height: 40)

                    
                VStack{
                    Spacer().frame(height: 60)

                    Text("Memories")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 20)
                ScrollView(.horizontal){
                        HStack(alignment: .center){
                            Spacer()
                    Image("helloWorld")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(20)
                        .foregroundColor(Color(colorSelection))
                            Spacer()
                    }.padding(.horizontal)
                }
                    Spacer().frame(height: 60)

                }
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                    
                // Split Payment
                
                    NavigationLink(destination:
                SplitPaymentView(colorSelection: colorSelection)){
                HStack(alignment: .center){
                VStack{
                    
                    Spacer().frame(height: 60)

                    Text("Split Payment")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 20)

                    Text("\(CurrencyManager.shared.getCurrencySign())10 Each")
                        .font(Font.custom("Poppins", size: 20))
                        .foregroundColor(Color(colorSelection))

                    Spacer().frame(height: 60)
                    
                }
                Spacer().frame(width: 40)
                VStack{
                    
                    Spacer().frame(height: 60)

                    Text("Total")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 20)

                    Text("\(CurrencyManager.shared.getCurrencySign())\(totalCost)")
                        .font(Font.custom("Poppins", size: 20))
                        .foregroundColor(Color(colorSelection))

                    Spacer().frame(height: 60)
                    
                }
                

            }
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                }
                //Experience
                VStack{
                    Spacer().frame(height: 60)

                    Text("Rate the Experience")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 20)
                    
                    
                    RatingView(rating: $rating, colorSelection: colorSelection)

                    Spacer().frame(height: 60)

                }
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                //Color
                VStack{
                    Spacer().frame(height: 60)

                    Text("Choose a Color")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 20)
                    HStack{
                        ForEach(colors, id: \.self) { color in
                            Spacer().frame(width: 5)
                            Button {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                   impactMed.impactOccurred()
                                colorSelection = color
                            } label: {
                                ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(color))
                                
                            if colorSelection == color {
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.white)
                                    }
                                }
                            }
           
                            Spacer().frame(width:10)
                            
                        }

                    }
                    Spacer().frame(height: 60)

                }
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                //Date
                VStack{
                    Spacer().frame(height: 60)

                    
                    Text("Choose a Date")
                        .foregroundColor(Color(colorSelection))
                    Spacer().frame(height: 10)
                    Text(selectedDate, style: .date)
                        .font(Font.custom("Poppins", size: 20))

                        .foregroundColor(Color(colorSelection))
                        .onTapGesture {
                            self.showsDatePicker.toggle()
                        }
                        
                   
                    
                    if showsDatePicker{
                        
                        DatePicker(
                                "",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                        .datePickerStyle(CompactDatePickerStyle())
                        .accentColor(Color(colorSelection))
                        .labelsHidden()
                        
                    }
                    
                      
                    
                    
                    Spacer().frame(height: 60)

                    
                }
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                    
                Spacer()
                }
                .frame(width: 600, height: 850)
                .ignoresSafeArea()

                .background(Color(.white))
                
                
            }

            
           
            

        }
        .background(Color(colorSelection))
        .navigationBarTitle("")
        .navigationBarItems(trailing:
            
                                
            Button(action: {
            CoreDataManager.shared.saveVault(id: UUID(), name: addVaultName, color: colorSelection, vault: vaultBudget, emoji: addEmoji, date: Date(), progress: String(Int(vaultProgress)), split: splitAmount)
            
            // This will close our sheet view when the user click our Add button.
            self.addVault.toggle()        }, label: {
            Text("save")
                .foregroundColor(.white)
        }))
        .navigationBarItems(leading:
            Button(action: {
            self.addVault.toggle()
        }, label: {
            Text("cancel")
                .foregroundColor(.white)

            }))
        }
    }
}

struct VaultListRowView: View {
    
    @Binding var deleteItems: Bool
    @ObservedObject var vault: Vaults
    
    @State var animate = false
    @State var showUpdateSheet = false
    @State var ShowingAlert = false

    
    var userVaultProgressCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: vault.progress ?? "") {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    
    var userVaultCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: vault.vault ?? "") {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    var body: some View {
       

        ZStack(alignment: .topTrailing){
            
            HStack {
                VStack(alignment: .center){
                  
                    ZStack{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .shadow(radius: 2)
                        
                        Text(vault.emoji ?? "")
                            .font(.system(size: 30))
                        
                    }
                    
                    Text(vault.name ?? "")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 15))
                        .frame(maxWidth: .infinity, alignment: .center)

                }
                    
                    
                /*
                    ZStack{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .shadow(radius: 2)
                        
                        Text(vault.emoji ?? "")
                            .font(.system(size: 25))
                        
                    }
                
                    Text(vault.name ?? "")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 15))
                                        
                    Text(vault.date ?? Date(), style: .date)
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 10))
                    Spacer()
                        .frame(height: 5)
                                        
                    Text("$\(vault.progress ?? "")/$\(vault.vault ?? "")")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins", size: 15))
                    Spacer()
                        .frame(height: 10)
                    ZStack(alignment: .leading){
                        
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 120, height: 15)
                            .foregroundColor(Color(vault.color ?? "red"))
                            .brightness(-0.1)
                        
                        if userVaultCGFloat != 0.0{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 120*(userVaultProgressCGFloat/userVaultCGFloat), height: 15)
                                .foregroundColor(Color(.white))
                        }
                        

                    }
                    
                }
                */
                .padding(.all)
                
            }
            .frame(width: 175, height: 175, alignment: .center)
            .background(Color(vault.color ?? "red"))
            .cornerRadius(20)

            
            if deleteItems{
                Button(action: {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                       impactMed.impactOccurred()
                    ShowingAlert = true
                    animate = true
                    CoreDataManager.shared.deleteVaults(vault: vault)
                }) {
                    ZStack{
                        Circle()
                            .fill(Color("red"))
                            .frame(width: 30, height: 30)
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    
                }
                .offset(x: 10, y: -10)
            }
            
            
        }
        .opacity(animate ? 0 : 1)
        .offset(x: animate ? 300 : 0)
        .animation(.spring())
        .onTapGesture {
            showUpdateSheet = true
        }
        
        .sheet(isPresented: $showUpdateSheet){
            UpdateVaultView(progress: Double(vault.progress ?? "") ?? 0.0, name: vault.name ?? "", color: vault.color ?? "", emoji: vault.emoji ?? "", vault: vault.vault ?? "", showUpdateSheet: $showUpdateSheet, vaultObject: vault)
            
        }
    }
}

struct UpdateVaultView: View {
    
    @State var progress: Double
    @State var name: String
    @State var color: String
    @State var emoji: String
    @State var vault: String
    @FocusState var isInputActive: Bool
    @Binding var showUpdateSheet: Bool
    
    let vaultObject: Vaults
    
    let colors = ["red", "orange", "yellow", "green","blue", "darkBlue"]
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
               
                
                VStack {
                    
                    Text("Chose an Emoji")
                        .foregroundColor(.gray)
                    TextField("+", text: self.$emoji.max(1))
                        .font(.system(size: 70))
                        .multilineTextAlignment(.center)
                        .focused($isInputActive)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()

                                Button("Done") {
                                    isInputActive = false
                                }
                            }
                        }
                    
                    
                    
                        .padding()
                    
                    Text("Vault Name: ")
                        .foregroundColor(.gray)
                    TextField("add name", text: self.$name.max(15))
                        .foregroundColor(Color(color))
                        .font(.system(size: 30))
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .focused($isInputActive)
                        
                    
                    Group {
                        
                        Text("Vault: ")
                            .foregroundColor(.gray)
                        
                        HStack {
                            
                            Text("$")
                                .font(.system(size: 30))
                                .foregroundColor(Color(color))
                            
                            TextField("0", text: self.$vault.max(4))
                                .foregroundColor(Color(color))
                                .font(.system(size: 25))
                                .keyboardType(.decimalPad)
                            
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .focused($isInputActive)
                               
                            
                        }
                        

                        
                        
                        Text("Vault Progress: ")
                            .foregroundColor(.gray)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        if let vault = Double(vault) {
                            Text("$\(progress, specifier: "%.0f")")
                                .foregroundColor(Color(color))
                                .font(.system(size: 30))
                            Slider(
                                value: $progress,
                                in: 0...vault,
                                step: 1
                            )
                            
                                .accentColor(Color(color))
                                .frame(width: 270)
                        }
                    }
                    
                    HStack{
                        ForEach(colors, id: \.self) { selectedColor in
                            Spacer()
                            Button {
                                color = selectedColor
                            } label: {
                                ZStack{
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(selectedColor))
                                
                            if color == selectedColor {
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.white)
                                    
                                    }
                                }
                                
                            }
                            
                            Spacer()
                        }
                        
                    }
                    .frame(width: 300)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Button that will submit our data to the list and reset our user selected
                    // variables for when then add another item.

                    if name.isEmpty || vault.isEmpty {
                        
                        
                    }else {
                        
                        Button(action: {
                            // update vault to core data
                            CoreDataManager.shared.updateVault(progress: String(Int(progress)), name: name, color: color, emoji: emoji, vault: vault, vaultObject: vaultObject)
                            
                            showUpdateSheet = false
                            
                        }, label: {
                            Text("Update Vault")
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 250, height: 50)
                                .background(Color(color))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                                .font(.system(size: 17))
                        })

                        
                    }
                    
                   
                }.padding(100)
                
                    .frame(width: 330, height: 650)
                    .background(.white)
                    .cornerRadius(15)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(color))
            .navigationBarHidden(true)

            
        }
 
    }
}

struct RatingView: View {
    

    @Binding var rating: Int

    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]
    var colorSelection: String = "blue"


var body: some View {
        
        
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .resizable()
                    .foregroundColor(number > rating ? offColor : Color(colorSelection))
                    .frame(width: 30, height: 30)
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

struct SplitPaymentView: View {
    
    @State private var totalCost = ""
    @State private var people: Double = 1
    @State private var tipIndex = 2
    @State private var tipPercentages: Double = 1
    @FocusState var isInputActive: Bool
    @State var colorSelection: String = "blue"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]

    
    func calculateTotal() -> Double {
        
        let tip = Double(tipPercentages)
        let orderTotal = Double(totalCost) ?? 0
        let finalAmount = ((orderTotal / 100 * tip) + orderTotal)
        return finalAmount / Double(people)
        
    }
    
    
    var body: some View {
        

            ScrollView(showsIndicators: false){
            VStack{
                
                //Enter Amount
                VStack(alignment: .center){
        
                Text("Bill Amount")
                TextField("\(CurrencyManager.shared.getCurrencySign())", text: $totalCost).keyboardType(.decimalPad)
                .foregroundColor(.black)
                .font(Font.custom("Poppins", size: 30))
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
                    
                 
                    
                }
                .foregroundColor(Color(colorSelection))
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 120)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                
                //Tip
                VStack{
           

                    if let tipPercentages = Double(tipPercentages) {
                        Text("Tip Percentage")
                        Text("\(tipPercentages, specifier: "%.0f")%")
                            .foregroundColor(Color(.black))
                            .font(Font.custom("Poppins", size: 25))
                        HStack{
                            
                            Button {
                                self.tipPercentages -= 1.0
                                if tipPercentages <= 0 { self.tipPercentages = 0 }

                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        
                                    }
                        
                        Slider(
                            value: $tipPercentages,
                            in: 0...30,
                            step: 1
                        )
                        .accentColor(Color(.black))
                           
                            Button {
                                self.tipPercentages += 1.0
                                if tipPercentages >= 30 { self.tipPercentages = 30 }

                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                                .resizable()
                                                .frame(width: 20, height: 20)                                    }

                        }
                        .frame(width: 270)

                    }
                    
                    
                }
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 170)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                
                //People
                VStack{
               

                        if let people = Double(people) {
                            Text("How Many People?")
                            
                            if people == 1.0 {
                                
                                Text("\(people, specifier: "%.0f") person")
                                    .foregroundColor(Color(.black))
                                    .font(Font.custom("Poppins", size: 25))
                               
                            }else {
                            Text("\(people, specifier: "%.0f") people")
                                .foregroundColor(Color(.black))
                                .font(Font.custom("Poppins", size: 25))
                            }
                            
                            
                            HStack{
                                
                                Button {
                                    self.people -= 1.0
                                    if people <= 1 { self.people = 1 }

                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)                                    }
                            
                            Slider(
                                value: $people,
                                in: 1...30,
                                step: 1
                            )
                            .accentColor(Color(.black))
                               
                                Button {
                                    self.people += 1.0
                                    if people >= 30 { self.people = 30 }

                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)                                    }

                            }
                            .frame(width: 270)


                        }
                        
                        
                    }
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 170)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                
                //Total
                VStack{
               
                    Text("Total Per Person")
                    Text("\(CurrencyManager.shared.getCurrencySign())\(calculateTotal(), specifier: "%.2f")")
                        .foregroundColor(.black)
                        .font(Font.custom("Poppins", size: 50))


                        
                    }
                .multilineTextAlignment(.center)
                .frame(width: 330, height: 170)
                .background(Color.white)
                .cornerRadius(20)
                .padding()
                .shadow(color: Color.gray.opacity(0.2), radius: 15.0, x:0, y:5)
                
                Button {
                    presentationMode.wrappedValue.dismiss()

                } label: {
                    Text("save")
                        .font(Font.custom("Poppins", size: 20))
                        .frame(width: 330, height: 60)
                        .background(Color(colorSelection))
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }

            
            }
            .navigationTitle("Split Payment")
            .foregroundColor(Color(colorSelection))
            .accentColor(Color(colorSelection))

        }
        
        
        
    }

}

struct VaultsView_Preview: PreviewProvider {
    static var previews: some View {
        VaultsView()
            .previewDevice("iPhone 13")
            
    }
}
