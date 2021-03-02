//
//  CoreDataStorage.swift
//  Todo
//
//  Created by Айдана on 1/9/21.
//

import Foundation
import CoreData

final class CoreDataStorage {

    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }

    func save(title: String, subtitle: String) {
        let task = Task(context: container.viewContext)
        task.name = title
        task.information = subtitle
        task.isCompleted = false
        
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }

    func fetchTodoTasks(isCompleted: Bool) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Todo.Task.isCompleted), NSNumber(value: isCompleted))
        fetchRequest.predicate = predicate
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    func delete(task: Task) {
        container.viewContext.delete(task)
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }

    func update() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
            }
        }
    }
}
