//
//  GoalsView.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 01.01.2022.
//


import SwiftUI
import CoreData
//import XCTest


struct GoalsView : View {
    
    @FetchRequest(
        entity: Goals.entity(),
        sortDescriptors: [
         NSSortDescriptor(keyPath: \Goals.date, ascending: false)
        ]
    ) var goals: FetchedResults<Goals>
    

    @State var myColor = Color(red: 0.997, green: 0.383, blue: 0.405) //tint color
    @State var addGoal = false
    
    @State var deleteItems = false
    
    var items: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    
    var body: some View {
        NavigationView {
            VStack {
                if (goals.isEmpty){
                    Text("🚀")
                        .font(.system(size: 60))
                        .opacity(0.5)
                    Spacer()
                        .frame(height: 10)
                    Text("No Active Goals")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .opacity(0.3)
                    Text("Create a Goal by clicking the + button at the top of the screen")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .opacity(0.3)
                        .padding(.vertical, 1.0)
                        .padding(.horizontal, 80)
                        .lineSpacing(5)
                    
                }
                
                else{
                    ScrollView {
                        LazyVGrid(columns: items){
                        ForEach(goals, id: \.id) { goal in
                            
                            GoalListRowView(deleteItems: $deleteItems, goal: goal)
                            }
                            .onDelete{ indexSet in
                                deleteGoalInList(at: indexSet)
                            }
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            .navigationBarTitle(Text("Goals 🚀"))
            .navigationBarItems(trailing:
                                    Button(action: {
                self.addGoal.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .navigationBarItems(trailing:
                                    Button(action: {
                deleteItems.toggle()
            }, label: {
                Text(deleteItems ? "Done" : "Edit")
            }))
            .accentColor(myColor)
        }
        .sheet(isPresented: $addGoal) {
            AddGoalView(addGoal: $addGoal)
        }
        .font(Font.custom("Poppins", size: 15))
        
    }

    private func deleteGoalInList(at offsets: IndexSet) {
        for index in offsets {
            let goal = goals[index]
            CoreDataManager.shared.persistentContainer.viewContext.delete(goal)
            CoreDataManager.shared.saveContext()
        }
    }
    
}


struct GoalModel: Hashable {
    let name: String
    let color: UIColor
    let emoji: String
    let budget: String
}

struct AddGoalView: View {
    
    @State var goalProgress: Double = 10.0
    @Binding var addGoal: Bool
    @State private var selectedColorIndex = 0
    @State var showSheetView = false
    @State private var isEditing = false
    @State var addGoalName: String = "goal name"
    @State var colorSelection: String = "red"
    @State var addEmoji: String = "🚀"
    @State private var goalBudget: String = "10"
   
    
    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]
    
    var body: some View {
        ZStack{
            
            VStack {
                
                Text("Chose an Emoji")
                    .foregroundColor(.gray)
                TextField("+", text: self.$addEmoji.max(1))
                    .font(.system(size: 70))
                    .multilineTextAlignment(.center)
                
                
                    .padding()
                
                Text("Goal Name: ")
                    .foregroundColor(.gray)
                TextField("name", text: self.$addGoalName.max(20))
                    .foregroundColor(Color(colorSelection))
                    .font(.system(size: 30))
                    .frame(width: 300)
                
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Group {
                    
                    Text("Goal: ")
                        .foregroundColor(.gray)
                    
                    HStack {
                        
                        Text("$")
                            .font(.system(size: 30))
                            .foregroundColor(Color(colorSelection))
                        
                        TextField("0", text: self.$goalBudget.max(4))
                            .foregroundColor(Color(colorSelection))
                            .font(.system(size: 25))
                            .keyboardType(.decimalPad)
                        
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                    }
                    
                    
                    Text("Goal Progress: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    if let goal = Double(goalBudget) {
                        Text("$\(goalProgress, specifier: "%.0f")")
                            .foregroundColor(Color(colorSelection))
                            .font(.system(size: 30))
                        Slider(
                            value: $goalProgress,
                            in: 0...goal,
                            step: 1,
                            
                            onEditingChanged: { editing in
                                isEditing = editing } )
                        
                            .accentColor(Color(colorSelection))
                            .frame(width: 270)
                    }
                }
                
                HStack{
                    ForEach(colors, id: \.self) { color in
                        Spacer()
                        Button {
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
                        
                        Spacer()
                    }
                    
                }
                .frame(width: 300)
                
                Spacer()
                    .frame(height: 30)
                
                // Button that will submit our data to the list and reset our user selected
                // variables for when then add another item.
                Button(action: {
                    // save goal to core data
                    CoreDataManager.shared.saveGoal(id: UUID(), name: addGoalName, color: colorSelection, progress: String(Int(goalProgress)), goal: goalBudget, emoji: addEmoji, date: Date())
                    
                    // This will close our sheet view when the user click our Add button.
                    self.addGoal.toggle()
                    
                }, label: {
                    Text("Create Goal")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color(colorSelection))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                })
            }.padding(100)
            
                .frame(width: 330, height: 650)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(colorSelection))
    }
}

struct GoalListRowView: View {
    
    @Binding var deleteItems: Bool
    let goal: Goals
    
    @State var animate = false
    @State var showUpdateSheet = false
    
    var userProgressCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: goal.progress ?? "") {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    var userGoalCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: goal.goal ?? "") {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing){
            
            HStack {
                VStack{
                    
                    ZStack{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .shadow(radius: 2)
                        
                        Text(goal.emoji ?? "")
                            .font(.system(size: 20))
                        
                        
                    }
                    .padding(.trailing, 10)
                    .padding()
                    
                    Text(goal.name ?? "")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 20))
                        .frame(maxWidth: .infinity, alignment: .center)

                    
                    Spacer()
                        .frame(height: 15)
                    
                    HStack{
                       
                        Text("$\(goal.progress ?? "")/$\(goal.goal ?? "")")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins", size: 15))
                            .offset(x: 30)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)


                    
                    Spacer()
                        .frame(height: 10)
                    
                    
                    ZStack(alignment: .leading){
                        
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 120, height: 15)
                            .foregroundColor(Color(goal.color ?? "red"))
                            .brightness(-0.1)
                        
                        if userGoalCGFloat != 0.0{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 120*(userProgressCGFloat/userGoalCGFloat), height: 15)
                                .foregroundColor(Color(.white))
                        }
                        

                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                .padding()
                
                Spacer()
                
                
                
            }
            .background(Color(goal.color ?? "red"))
            .cornerRadius(20)
            .listRowSeparator(.hidden)
            .padding(.top)
            
            if deleteItems{
                Button(action: {
                    animate = true
                    CoreDataManager.shared.deleteGoal(goal: goal)
                }) {
                    ZStack{
                        Circle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    
                }
                .offset(y: 6)
            }
            
        }
        .opacity(animate ? 0 : 1)
        .offset(x: animate ? 300 : 0)
        .animation(.spring())
        .onTapGesture {
            showUpdateSheet = true
        }
        .sheet(isPresented: $showUpdateSheet){
            UpdateGoalView(progress: Double(goal.progress ?? "") ?? 0.0, name: goal.name ?? "", color: goal.color ?? "", emoji: goal.emoji ?? "", goal: goal.goal ?? "")
        }
    }
}

struct UpdateGoalView: View {
    
    @State var progress: Double
    @State var name: String
    @State var color: String
    @State var emoji: String
    @State var goal: String
   
    
    let colors = [ "red", "orange", "yellow", "green","blue", "darkBlue"]
    
    var body: some View {
        ZStack{
            
            VStack {
                
                Text("Chose an Emoji")
                    .foregroundColor(.gray)
                TextField("+", text: self.$emoji.max(1))
                    .font(.system(size: 70))
                    .multilineTextAlignment(.center)
                
                
                    .padding()
                
                Text("Goal Name: ")
                    .foregroundColor(.gray)
                TextField("name", text: self.$name.max(20))
                    .foregroundColor(Color(color))
                    .font(.system(size: 30))
                    .frame(width: 300)
                
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Group {
                    
                    Text("Goal: ")
                        .foregroundColor(.gray)
                    
                    HStack {
                        
                        Text("$")
                            .font(.system(size: 30))
                            .foregroundColor(Color(color))
                        
                        TextField("0", text: self.$goal.max(4))
                            .foregroundColor(Color(color))
                            .font(.system(size: 25))
                            .keyboardType(.decimalPad)
                        
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                    }
                    
                    
                    Text("Goal Progress: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    if let goal = Double(goal) {
                        Text("$\(progress, specifier: "%.0f")")
                            .foregroundColor(Color(color))
                            .font(.system(size: 30))
                        Slider(
                            value: $progress,
                            in: 0...goal,
                            step: 1
                        )
                        
                            .accentColor(Color(color))
                            .frame(width: 270)
                    }
                }
                
                HStack{
                    ForEach(colors, id: \.self) { color in
                        Spacer()
                        Button {
                            color = color
                        } label: {
                            ZStack{
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(color))
                            
                        if color == color {
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
                Button(action: {
                    // update goal to core data
                    
                }, label: {
                    Text("Update Goal")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 250, height: 50)
                        .background(Color(color))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                })
            }.padding(100)
            
                .frame(width: 330, height: 650)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(color))
    }
}


struct GoalsView_Preview: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .previewDevice("iPhone 13")
            
    }
}
