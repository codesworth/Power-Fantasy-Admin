//
//  CXFAccountTransaction+CoreDataProperties.swift
//  
//
//  Created by Mensah Shadrach on 2/17/18.
//
//

import Foundation
import CoreData


extension CXFAccountTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CXFAccountTransaction> {
        return NSFetchRequest<CXFAccountTransaction>(entityName: "CXFAccountTransaction")
    }

    @NSManaged public var id: String?
    @NSManaged public var ltrans: NSObject?
    @NSManaged public var cluid: String?
    @NSManaged public var account: NSObject?
    @NSManaged public var transType: Int16
    @NSManaged public var pMethod: Int16
    @NSManaged public var finalDetail: String?
    @NSManaged public var state: Int16

}
