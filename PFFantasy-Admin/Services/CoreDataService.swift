//
//  CoreDataService.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData

class CoreService {
    
    private static let _service = CoreService()
    
    static var service:CoreService{
        return _service
    }
    
    
    func fetchLogs()->[Logger?]{
        var sgroup = [Logger]()
        let fetchRequest = NSFetchRequest<Logger>(entityName: String(describing:Logger.self))
        
        do {
            sgroup = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        return sgroup
    }
    
    func fetchAdmins()->[Admins]{
        var sgroup = [Admins]()
        let fetchRequest = NSFetchRequest<Admins>(entityName: String(describing:Admins.self))
        
        do {
            sgroup = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        return sgroup
    }
}
