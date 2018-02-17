//
//  Logger+CoreDataProperties.swift
//  
//
//  Created by Mensah Shadrach on 2/15/18.
//
//

import Foundation
import CoreData


extension Logger {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Logger> {
        return NSFetchRequest<Logger>(entityName: "Logger")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var domain: String?
    @NSManaged public var serial: String?
    @NSManaged public var agentID: String?
    @NSManaged public var statement: String?
    @NSManaged public var relationship: NSManagedObject?

}
