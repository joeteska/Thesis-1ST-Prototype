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
    
    
    let persistentContainer : NSPersistentContainer
    
    init() {
        
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
    
    func saveGoal(id: UUID, name: String, color: String, progress: String, goal: String, emoji: String) {
        
        
        let myGoal = Goals(context: persistentContainer.viewContext)
        myGoal.id = id
        myGoal.name = name
        myGoal.color = color
        myGoal.progress = progress
        myGoal.goal = goal
        myGoal.emoji = emoji
        
        saveContext()
        
    }

    
}

