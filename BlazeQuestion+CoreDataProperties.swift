//
//  BlazeQuestion+CoreDataProperties.swift
//  
//
//  Created by Mensah Shadrach on 2/17/18.
//
//

import Foundation
import CoreData


extension BlazeQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlazeQuestion> {
        return NSFetchRequest<BlazeQuestion>(entityName: "BlazeQuestion")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var choice: NSObject?

}
