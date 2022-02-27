//
//  Thesis_1ST_PrototypeApp.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 29.12.2021.
//

import SwiftUI
import CoreData

@main
struct DolfinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
