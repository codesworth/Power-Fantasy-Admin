//
//  CXFLTransaction+CoreDataProperties.swift
//  
//
//  Created by Mensah Shadrach on 2/17/18.
//
//

import Foundation
import CoreData


extension CXFLTransaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CXFLTransaction> {
        return NSFetchRequest<CXFLTransaction>(entityName: "CXFLTransaction")
    }

    @NSManaged public var id: String?
    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var balance: Double
    @NSManaged public var pin: String?
    @NSManaged public var isCredit: Bool

}
