//
//  TasksView.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 01.01.2022.
//


import SwiftUI
import CoreData
//import XCTest


struct TasksView : View {
    
    @FetchRequest(
        entity: Tasks.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tasks.name, ascending: true)
        ]
    ) var tasks: FetchedResults<Tasks>
    
    
    
    @State var myColor = Color(red: 0.997, green: 0.383, blue: 0.405) //tint color
    @State var addTask = false
    
    var body: some View {
        NavigationView {
            VStack {
                if (tasks.isEmpty){
                    Text("✏️")
                        .font(.system(size: 60))
                        .opacity(0.3)
                    Spacer()
                        .frame(height: 10)
                    Text("No Active Tasks")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .opacity(0.3)
                    Text("Create a Task by clicking the + button at the top of the screen")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .opacity(0.3)
                        .padding(.vertical, 1.0)
                        .padding(.horizontal, 80)
                }
                
                else{
                    List {
                        ForEach(tasks.reversed(), id: \.id) { task in
                            TaskListRowView(name: task.name ?? "", task: task.task ?? "", emoji: task.emoji ?? "", color: task.color ?? "red")
                        }
                        
                        .onDelete{ indexSet in
                            deleteTaskInList(at: indexSet)
                        }
                        .onMove { (indexSet, index) in
                            //self.$goals.move(fromOffsets: indexSet, toOffset: index)
                        }
                        
                        
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            .navigationBarTitle(Text("Tasks ✏️"))
            .navigationBarItems(trailing:
                                    Button(action: {
                self.addTask.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .navigationBarItems(trailing: EditButton())
            .accentColor(myColor)
        }
        .sheet(isPresented: $addTask) {
            AddTaskView(addTask: $addTask)
        }
        .font(Font.custom("Poppins", size: 15))
        
    }

    private func deleteTaskInList(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            CoreDataManager.shared.persistentContainer.viewContext.delete(task)
            CoreDataManager.shared.saveContext()
        }
    }
    
}


struct TaskModel: Hashable {
    let name: String
    let color: UIColor
    let emoji: String
    let budget: String
}




struct AddTaskView: View {
    
    @State private var selectedColorIndex = 0
    @State var showSheetView = false
    @State var addTaskName: String = "task name"
    @State var colorSelection: String = "orange"
    @State var addEmoji: String = "🐶"
    @State private var taskBudget: String = "10"
    @State var isEmpty = false
    @State var speed = 0.0
    @State private var isEditing = false
    @Binding var addTask: Bool
    
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
                
                Text("Task Name: ")
                    .foregroundColor(.gray)
                TextField("name", text: self.$addTaskName.max(20))
                    .foregroundColor(Color(colorSelection))
                    .font(.system(size: 30))
                    .frame(width: 300)
                
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Group {
                    
                    Text("Task: ")
                        .foregroundColor(.gray)
                    
                    HStack {
                        
                        Text("$")
                            .font(.system(size: 30))
                            .foregroundColor(Color(colorSelection))
                        
                        TextField("0", text: self.$taskBudget.max(4))
                            .foregroundColor(Color(colorSelection))
                            .font(.system(size: 25))
                            .keyboardType(.decimalPad)
                        
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                    }
                    
                    
                    Text("Task Progress: ")
                        .foregroundColor(.gray)
                    
                    Spacer()
                        .frame(height: 30)
                    
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
                    CoreDataManager.shared.saveTask(id: UUID(), name: addTaskName, color: colorSelection, task: taskBudget, emoji: addEmoji)
                    
                    // This will close our sheet view when the user click our Add button.
                    self.addTask.toggle()
                    
                }, label: {
                    Text("Create Task")
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

struct TaskListRowView: View {
    
    let name: String
    let task: String
    let emoji: String
    let color: String
    
    var body: some View {
        HStack {
            VStack{
                Text(name)
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 20)
                
                HStack{
                    Text("$")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 20))
                    Text("\(task)")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 20))
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
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
            .padding()
            
            
            
        }
        .frame(height: 160)
        .background(Color(color))
        .cornerRadius(20)
        .listRowSeparator(.hidden)
        .padding(.top)
    }
}


struct NewTasks_Preview: PreviewProvider {
    static var previews: some View {
        TasksView()
            .previewDevice("iPhone 13")
            
    }
}
