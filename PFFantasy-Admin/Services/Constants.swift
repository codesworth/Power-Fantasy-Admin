//
//  Constants.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import AppKit




/*******************************************************************************************/
//PATHS

let BASEURL = "http://localhost:3000/api/v1"
let leaguesPath = "\(BASEURL)/Leagues"
let BLAZEPATH = "\(BASEURL)/BlazeLeague"
var CREDITPATH = "\(BASEURL)/Credit"
var PATH_CONTEST = "\(BASEURL)/Contests"
var PATH_PLAYERS = "\(BASEURL)/Players"
var PATH_QUESTIONS = "\(BASEURL)/Questions"
let PATH_TRANSACT = "\(BASEURL)/Transactions"
let PATH_NEWUSERS = "\(BASEURL)/NewUsers"

/*******************************************************************************************/



public var AgentID:String = ""
public  var SERIAL = ""
var ACCESS_LEVEL:String = AccessLevel.noAccess.rawValue
var LOG_DOMAIN:String = ""




func alert(title:String, message:String){
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.informativeText = "Please enter user ID and Password"
    alert.messageText = "Invalid User ID and password Fields"
    alert.runModal()
}


func log(_ message:String){
    Swift.print(message)
}

func getMachineSerial()->String{
    var serialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
        
        guard platformExpert > 0 else {
            return nil
        }
        
        guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String) else {
            return nil
        }
        
        
        IOObjectRelease(platformExpert)
        
        return serialNumber
    }
    return ""
}
