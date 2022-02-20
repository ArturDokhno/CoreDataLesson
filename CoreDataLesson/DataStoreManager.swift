//
//  DataStoreManager.swift
//  CoreDataLesson
//
//  Created by Артур Дохно on 19.02.2022.
//

import Foundation
import CoreData

class DataStoreManager {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataLesson")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func obtainModelUser() -> User {
        
        let feachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        feachRequest.predicate = NSPredicate(format: "isMain = true")
        
        if let users = try? viewContext.fetch(feachRequest) as? [User], !users.isEmpty {
            
            return users.first!
        } else {
            let company = Company(context: viewContext)
            company.name = "Apple Company"
            
            let user = User(context: viewContext)
            user.name = "Artur"
            user.age = 29
            user.company = company
            user.isMain = true
            
            do {
                try viewContext.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            return user
        }
    }
    
    func updateMainUser(with name: String) {
        
        let feachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        feachRequest.predicate = NSPredicate(format: "isMain = true")
        
        if let users = try? viewContext.fetch(feachRequest) as? [User] {
            
            guard let mainUser = users.first else { return }
            
            mainUser.name = name
            
            try? viewContext.save()
        }
    }
    
    func removeNameUser() {
        
        let feachRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        feachRequest.predicate = NSPredicate(format: "isMain = true")
        
        if let users = try? backgroundContext.fetch(feachRequest) as? [User] {
            
            guard let mainUser = users.first else { return }
            
            backgroundContext.delete(mainUser)
            
            try? backgroundContext.save()
        }
        
    }
    
    
}
