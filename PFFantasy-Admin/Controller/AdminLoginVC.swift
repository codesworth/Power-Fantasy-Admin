//
//  AdminLoginVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/14/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa


class AdminLoginVC: NSViewController {

    @IBOutlet weak var dividerview: NSView!
    @IBOutlet weak var loginButt: NSButton!
    @IBOutlet weak var passwrdtext: NSTextField!
    @IBOutlet weak var useridtxt: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setup()
        
    }
    
    
    func setup(){
        dividerview.wantsLayer = true
        loginButt.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        loginButt.layer?.cornerRadius = 20
        loginButt.layer?.backgroundColor = NSColor(calibratedRed: 10/255, green: 201/255, blue: 217/255, alpha: 1).cgColor
        dividerview.layer?.backgroundColor = NSColor(calibratedRed: 10/255, green: 201/255, blue: 217/255, alpha: 1).cgColor
    }
    
    
    
}
