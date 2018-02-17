//
//  AccountsVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/16/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

enum CXMenuItems:String{
    case withrawal
}

class AccountsVC: NSViewController {

    @IBOutlet weak var searchbutt: FlatButton!
    @IBOutlet weak var comment: NSTextField!
    @IBOutlet weak var paymentID: NSTextField!
    @IBOutlet weak var referenceID: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var paymentType: NSTextField!
    @IBOutlet weak var accNumber: NSTextField!
    @IBOutlet weak var accName: NSTextField!
    @IBOutlet weak var detview: NSView!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        // Do view setup here.
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(nil)
    }
    @IBAction func searchPressed(_ sender: FlatButton) {
        
    }
    @IBAction func confirm(_ sender: FlatButton) {
        
    }
}
