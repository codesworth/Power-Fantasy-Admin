//
//  AccoutsCell.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/16/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class AccoutsCell: NSTableCellView {

    @IBOutlet weak var playerwins: NSTextField!
    @IBOutlet weak var amount: NSTextField!
    @IBOutlet weak var username: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func configure(account:CXFCreditAccount,win:Double,contestType:Int32){
        playerwins.stringValue = "GH \(win)"
        username.stringValue = account.name!
        if contestType == Int32(CONTEST_BLAZE) {
            amount.stringValue = "GH \(account.virtualCoins)"
        }else if contestType == Int32(CONTEST_REGULAR){
            amount.stringValue = "GH \(account.balance)"
        }
    }
    
}
