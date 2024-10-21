//
//  CoreDataConfiguration.swift
//  TheNewYorkTimes
//
//  Created by Alejandro Velasco on 18/10/24.
//

import Foundation
import CoreData
class CoreDataManager {
    static let shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ListArticles")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
