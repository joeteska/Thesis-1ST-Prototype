//
//  CoreDataManager.swift
//  Dolfin
//
//  Created by Josef Teska on 23.02.2022.
//

import Foundation
import CoreData
import SwiftUI


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store Failed \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            
            print("Error saving context, restoring updated objects to their last commited values.")
            persistentContainer.viewContext.rollback()
            
        }
        
    }
 
     
    func saveGoal(id: UUID, name: String, color: String, progress: String, goal: String, emoji: String, date: Date) {
        let myGoal = Goals(context: persistentContainer.viewContext)
        myGoal.id = id
        myGoal.name = name
        myGoal.color = color
        myGoal.progress = progress
        myGoal.goal = goal
        myGoal.emoji = emoji
        myGoal.date = date
        saveContext()
    }
    
    func deleteGoal(goal: Goals){
        persistentContainer.viewContext.delete(goal)
        saveContext()
    }
    
    func getAllGoals() -> [Goals]{
        let fetchRequest: NSFetchRequest<Goals> = Goals.fetchRequest()
        
        do{
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch{
            return []
        }
    }
    
    func deleteAllGoals(){
        let goals = getAllGoals()
        
        for goal in goals{
            persistentContainer.viewContext.delete(goal)
        }
        saveContext()
    }

    func updateGoal(progress: String, name: String, color: String, emoji: String, goal: String){
        
    }
    
    //progress tab for profile view - goals
    
    func getProgressAndTotal() -> (String, String){
        let goals = getAllGoals()
        
        var totalProgressAmount = 0
        var totalGoalAmount = 0
        
        for goal in goals{
            totalProgressAmount += Int(goal.progress ?? "")!
            totalGoalAmount += Int(goal.goal ?? "")!
        }
        return (String(totalProgressAmount), String(totalGoalAmount))
    }
    
    func getTotalTask() -> (String) {
        
        let tasks = getAllTasks()
        var totalTaskAmount = 0
        
        for task in tasks {
            if task.completed{
                totalTaskAmount += Int(task.task ?? "") ?? 0
            }
            
        }
        return(String(totalTaskAmount))
    }
     
    
    func saveTask(id: UUID, name: String, color: String, task: String, emoji: String, completed: Bool, date: Date) {
        let myTask = Tasks(context: persistentContainer.viewContext)
        myTask.id = id
        myTask.name = name
        myTask.color = color
        myTask.task = task
        myTask.emoji = emoji
        myTask.completed = completed
        myTask.date = date
        saveContext()
    }
    
    func deleteTasks(task: Tasks){
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    func getAllTasks() -> [Tasks]{
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do{
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch{
            return []
        }
    }
    
    func deleteAllTasks(){
        let tasks = getAllTasks()
        
        for task in tasks{
            persistentContainer.viewContext.delete(task)
        }
        saveContext()
    }
    
    func getCompletedTasks() -> (String,String){
        
        let tasks = getAllTasks()
        
        var completedTasks = 0
        
        for task in tasks {
            
            if task.completed{
                
                completedTasks += 1
                
            } 
        }
        print(String(completedTasks), String(tasks.count))
        return (String(completedTasks), String(tasks.count))

    }
    
    
}

