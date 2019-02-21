//
//  Extensions.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/16/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData


extension Admins{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        uid = UUID()
    }
}

extension Date{
    func unixTimestamp()->Int64{
        return Int64(timeIntervalSince1970 * 1000)
    }
    
}

extension NSObject{
    func stringify()->String{
        return "\(self)"
    }
}

extension RegularQuestions{
    
    func getOptions()->Extras{
        return options as! Extras
    }
}


extension CorrectPicks{
    
    func getCorrectOptions()->Extras{
        return correctOption as! Extras
    }
    
    func getCorrectActuals()->Extras?{
        return actuallPoints as? Extras
    }
}

extension RegularQuestions{
    
    @objc func alert(){
        PFFantasy_Admin.alert(title: "ERROR", message: "Unable to deactivate expired Contests")
    }
    
    public override func awakeFromInsert() {
        let backgroundTask = NSBackgroundActivityScheduler(identifier: self.id!)
        backgroundTask.interval = Date(timeIntervalSince1970: TimeInterval(timestamp)).timeIntervalSinceNow
        backgroundTask.qualityOfService = QualityOfService.default
        backgroundTask.repeats = false
        backgroundTask.schedule { (block) in
            Dataservice.service.invalidateActiveOnServer(uniqueID: self.id!, handler: { (success, error, data) in
                if success && data != nil{
                    block(.finished)
                }else{
                    Log.log(statement: "Unable to deactivate Active on Server with id: \(self.id!)", domain: LoggerDomain.regular.rawValue)
                    self.perform(#selector(self.alert), on: Thread.main, with: nil, waitUntilDone: false)
                    block(.finished)
                }
            })
        }
    }
}


extension BlazeQuestion{
    
    func getOptions()->Extras{
        return choice as! Extras
    }
    
    @objc func alert(){
        PFFantasy_Admin.alert(title: "ERROR", message: "Unable to deactivate expired Contests")
    }
    
    public override func awakeFromInsert() {
        let backgroundTask = NSBackgroundActivityScheduler(identifier: self.id!)
        backgroundTask.interval = Date(timeIntervalSince1970: TimeInterval(timestamp)).timeIntervalSinceNow
        backgroundTask.qualityOfService = QualityOfService.default
        backgroundTask.repeats = false
        backgroundTask.schedule { (block) in
            Dataservice.service.invalidateActiveOnServer(uniqueID: self.id!, handler: { (success, error, data) in
                if success && data != nil{
                    block(.finished)
                }else{
                    Log.log(statement: "Unable to deactivate Active on Server with id: \(self.id!)", domain: LoggerDomain.blazeNetwork.rawValue)
                    self.perform(#selector(self.alert), on: Thread.main, with: nil, waitUntilDone: false)
                    block(.finished)
                }
            })
        }
    }
}



