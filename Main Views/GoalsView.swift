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
    
    var body: some View {
        NavigationView {
            VStack {
                if (goals.isEmpty){
                    Text("🚀")
                        .font(.system(size: 60))
                        .opacity(0.1)
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
                }
                
                else{
                    List {
                        ForEach(goals, id: \.id) { goal in
                            GoalListRowView(name: goal.name ?? "", progress: goal.progress ?? "", goal: goal.goal ?? "", emoji: goal.emoji ?? "", color: goal.color ?? "red")
                        }
                        
                        .onDelete{ indexSet in
                            deleteGoalInList(at: indexSet)
                        }
                        .onMove { (indexSet, index) in
                            //self.$goals.move(fromOffsets: indexSet, toOffset: index)
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
            .navigationBarItems(trailing: EditButton())
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
   
    
    let colors = [ "red", "green", "blue", "yellow","darkBlue", "orange"]
    
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
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(color))
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
    
   
    
    
    let name: String
    let progress: String
    let goal: String
    let emoji: String
    let color: String
    
    var userProgressCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: progress) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    var userGoalCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: goal) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    
    var body: some View {
        HStack {
            VStack{
                Text(name)
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                Spacer()
                    .frame(height: 15)
                
                HStack{
                   
                    Text("$\(progress)/\(goal)")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 15))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                
                Spacer()
                    .frame(height: 10)
                
                
                ZStack(alignment: .leading){
                    
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 120, height: 15)
                        .foregroundColor(Color(color))
                        .brightness(-0.1)
                    
                    if userGoalCGFloat != 0.0{
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 120*(userProgressCGFloat/userGoalCGFloat), height: 15)
                            .foregroundColor(Color(.white))
                    }
                    

                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 30)
            
            .padding()
            
            Spacer()
            
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 2)
                
                Text(emoji)
                    .font(.system(size: 45))
                
                
            }
            .padding(.trailing, 10)
            .padding()
            
            
            
        }
        .frame(height: 160)
        .background(Color(color))
        .cornerRadius(20)
        .listRowSeparator(.hidden)
        .padding(.top)
    }
}


struct GoalsView_Preview: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .previewDevice("iPhone 13")
            
    }
}
