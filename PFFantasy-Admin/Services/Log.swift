//
//  Logger.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation

enum LoggerDomain:String{
    case authDomain = "Auth Domain"
    case dashboard = "DashBoard Domain"
    case startup = "StartUp Domain"
    case preferencePain = "Preference Domain"
}

func DECLAREDOMAIN(domain:LoggerDomain){
    LOG_DOMAIN = domain.rawValue
}

class Log{
    
    private static let _instance = Log()
    
    static var ins:Log{
        return _instance
    
    }

    static func log(statement:String, domain:String?){
        let log = Logger(context: CoreDataStack.persistentContainer.viewContext)
        log.date = Date()
        log.agentID = AgentID
        log.serial = SERIAL
        log.statement = statement
        log.accesLevel = ACCESS_LEVEL
        if(domain != nil){
            log.domain = domain
        }else{
            log.domain = LOG_DOMAIN
        }
        CoreDataStack.saveContext()
    }
    
}
