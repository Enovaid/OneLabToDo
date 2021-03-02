//
//  MainViewModel.swift
//  Todo
//
//  Created by Айдана on 1/9/21.
//

import Foundation

final class MainViewModel {
    let localStorage = CoreDataStorage()
    
    func save(title: String, subtitle: String) {
        localStorage.save(title: title, subtitle: subtitle)
    }
    
    func fetchTodoTasks(isCompleted: Bool) -> [Task] {
        return localStorage.fetchTodoTasks(isCompleted: isCompleted)
    }
    
    func delete(task: Task) {
        localStorage.delete(task: task)
    }
    
    func update() {
        localStorage.update()
    }
}
