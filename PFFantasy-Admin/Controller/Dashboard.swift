//
//  OptionsVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa



class Dashboard: NSViewController {

    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var logout: FlatButton!
    @IBOutlet weak var management: NSButton!
    @IBOutlet weak var accounts: NSButton!
    @IBOutlet weak var engine: NSButton!
    @IBOutlet weak var addcontest: NSButton!
    @IBOutlet weak var addquestions: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        DECLAREDOMAIN(domain: LoggerDomain.dashboard)
        view.wantsLayer = true
        username.stringValue = AgentID
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        //setup()
        /*let logs = CoreService.service.fetchLogs()
        for alog in logs{
            log("\(alog!.agentID!) \(alog!.statement!) in \(alog!.domain!)")
        }*/
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    func setup(){
        management.setneedsLayer(); management.bound(); management.setShadow()
        accounts.setneedsLayer(); accounts.bound(); accounts.setShadow()
        engine.setneedsLayer(); engine.bound(); engine.setShadow()
        addcontest.setneedsLayer(); addcontest.bound(); addcontest.setShadow()
        addquestions.setneedsLayer(); addquestions.bound(); addquestions.setShadow()
        
        /*let attributes =
            [
                NSAttributedStringKey.foregroundColor: NSColor.white,
                NSAttributedStringKey.font: NSFont() ,
                NSAttributedStringKey.paragraphStyle: NSMutableParagraphStyle()
                ] as [NSAttributedStringKey : Any]
        let atl = NSAttributedString(string: management.title, attributes: attributes)
        management.attributedTitle = atl*/
        
    }
    
    @IBAction func AddquestionPressed(_ sender: FlatButton) {
    }
    
    @IBAction func AddContestPressed(_ sender: FlatButton) {
    }
    @IBAction func EnginePressed(_ sender: FlatButton) {
    }
    @IBAction func AccountsPressed(_ sender: FlatButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("Accounts"), sender: nil)
    }
    @IBAction func ManagementPressed(_ sender: FlatButton) {
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        dismiss(nil)
        Log.log(statement: "Logged Out Admin Console", domain: nil)
        ACCESS_LEVEL = AccessLevel.noAccess.rawValue
    }
    
    
    
}


extension NSView{
    
    func setneedsLayer(){
        self.wantsLayer = true
    }
    
    func bound(_ radius:CGFloat = 5, color:NSColor = NSColor(calibratedRed: 10/255, green: 201/255, blue: 217/255, alpha: 1)){
        self.layer?.cornerRadius = radius
        layer?.backgroundColor = color.cgColor
    }
    
    func setShadow(){
        layer?.shadowColor = NSColor.lightGray.cgColor
        layer?.shadowOffset = CGSize(width: 0, height: 2)
        layer?.shadowRadius = 2.0
    }
    
}



