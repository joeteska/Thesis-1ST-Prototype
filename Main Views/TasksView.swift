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
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tasks.date, ascending: false)

        ],
        predicate: NSPredicate(format: "completed == false")
    ) var tasks: FetchedResults<Tasks>
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tasks.date, ascending: false)

        ],
        predicate: NSPredicate(format: "completed == true")
    ) var completedTasks: FetchedResults<Tasks>
    
    
    @State var showCompleted = false
    @State var myColor = Color(red: 0.997, green: 0.383, blue: 0.405) //tint color
    @State var addTask = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                    .frame(height: 20)
                
                HStack{
                    Button {
                        showCompleted = false
                    } label: {
                        Text("Active")
                    }
                    Spacer()
                        .frame(width: 200)
                    Button {
                        showCompleted = true
                    } label: {
                        Text("Completed")
                    }

                } .padding(.horizontal)
                
                Spacer()
                
                if !showCompleted{
                    if (tasks.isEmpty){
                        Text("✏️")
                            .font(.system(size: 60))
                            .opacity(0.5)
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
                            .lineSpacing(5)
                        Spacer()

                    }
                    
                    else{
                        List {
                            ForEach(tasks, id: \.id) { task in
                                TaskListRowView(task: task)
                                   
                            }
                            
                            .onDelete{ indexSet in
                                deleteItemInActive(at: indexSet)
                            }
                           
                            
                            
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                else{
                    if (completedTasks.isEmpty){
                        Text("🙈")
                            .font(.system(size: 60))
                            .opacity(0.5)
                        Spacer()
                            .frame(height: 10)
                        Text("Oops there's nothing here")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .opacity(0.3)
                        Spacer()

                    }
                    
                    else{
                        List {
                            ForEach(completedTasks, id: \.id) { task in
                                TaskListRowView(task: task)
                            }
                            
                            .onDelete{ indexSet in
                                deleteItemInCompleted(at: indexSet)
                            }
                       
                        }
                        .listStyle(PlainListStyle())
                    }
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

    private func deleteItemInActive(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            CoreDataManager.shared.persistentContainer.viewContext.delete(task)
            CoreDataManager.shared.saveContext()
        }
    }
    
    private func deleteItemInCompleted(at offsets: IndexSet) {
        for index in offsets {
            let task = completedTasks[index]
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
                
                Text("Task Name: ")
                    .foregroundColor(.gray)
                TextField("name", text: self.$addTaskName.max(18))
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
                    CoreDataManager.shared.saveTask(id: UUID(), name: addTaskName, color: colorSelection, task: taskBudget, emoji: addEmoji, completed: false, date: Date())
                    
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
            
                .frame(width: 330, height: 550)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(colorSelection))
    }
}

struct TaskListRowView: View {
    
    let task: Tasks
    
    var body: some View {
        HStack {
            VStack{
                Text(task.name ?? "")
                    .foregroundColor(.white)
                    .font(Font.custom("Poppins", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 10)
                
                HStack{
                  
                    Text("$\(task.task ?? "")")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins", size: 20))
                    Spacer()
                        .frame(width: 25)
                    Group {
                            
                            if !task.completed{
                                Button {
                                    task.completed = true
                                    CoreDataManager.shared.saveContext()
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            else{
                                Button {
                                    task.completed = false
                                    CoreDataManager.shared.saveContext()
                                } label: {
                                    Image(systemName: "arrowshape.turn.up.backward.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                    
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)

                                }
                            }
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                
    
            }
            
           
       
            .padding(.horizontal, 30)
            
            Spacer()
            
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 2)
                
                Text(task.emoji ?? "")
                    .font(.system(size: 45))
                
                
            }
            .padding(.trailing)
        }
        .frame(height: 160)
        .background(Color(task.color ?? "red"))
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
