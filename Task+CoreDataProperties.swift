//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Айдана on 1/10/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var information: String?
    @NSManaged public var name: String?
    @NSManaged public var isCompleted: Bool

}
