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


extension BlazeQuestion{
    
    func getOptions()->Extras{
        return choice as! Extras
    }
}



