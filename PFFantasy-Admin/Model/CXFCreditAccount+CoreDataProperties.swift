//
//  CXFCreditAccount+CoreDataProperties.swift
//  
//
//  Created by Mensah Shadrach on 2/17/18.
//
//

import Foundation
import CoreData


extension CXFCreditAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CXFCreditAccount> {
        return NSFetchRequest<CXFCreditAccount>(entityName: "CXFCreditAccount")
    }

    @NSManaged public var accountNo: String?
    @NSManaged public var name: String?

}
