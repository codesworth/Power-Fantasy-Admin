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
