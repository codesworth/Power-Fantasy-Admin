//
//  OptionsVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa
import CoreData


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
        CoreDatabase.service.trimAllLeagues()
        //saveColors()
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        //setup()
        /*let logs = CoreService.service.fetchLogs()
        for alog in logs{
            log("\(alog!.agentID!) \(alog!.statement!) in \(alog!.domain!)")
        }*/
        //CoreService.service.fixdate()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        username.stringValue = AgentID
    }
    
    func setup(){
        management.setneedsLayer(); management.bound(); management.setShadow()
        accounts.setneedsLayer(); accounts.bound(); accounts.setShadow()
        engine.setneedsLayer(); engine.bound(); engine.setShadow()
        addcontest.setneedsLayer(); addcontest.bound(); addcontest.setShadow()
        addquestions.setneedsLayer(); addquestions.bound(); addquestions.setShadow()

        
    }
    
    @IBAction func AddquestionPressed(_ sender: FlatButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("QuesHelper"), sender: nil)
    }
    
    @IBAction func AddContestPressed(_ sender: FlatButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("Contests"), sender: nil)
    }
    
    @IBAction func EnginePressed(_ sender: FlatButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("TOENGINE"), sender: nil)
    }
    
    @IBAction func AccountsPressed(_ sender: FlatButton) {
        
        
        //performSegue(withIdentifier:
        //NSStoryboardSegue.Identifier("Accounts"), sender: nil)
    }
    
    @IBAction func ManagementPressed(_ sender: FlatButton) {
        performSegue(withIdentifier: NSStoryboardSegue.Identifier("FantasyAnalyze"), sender: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        Log.log(statement: "Logged Out Admin Console", domain: nil)
        ACCESS_LEVEL = AccessLevel.noAccess.rawValue
        dismiss(nil)
    }
    
    
    func saveColors(){
        let allcolors = CoreDatabase.service.fetchAllColors();
        for item in allcolors {
            CoreDataStack.persistentContainer.viewContext.delete(item)
            CoreDataStack.saveContext();
        }
        for (key, color) in colors{
            let colobj = TeamColor(context: CoreDataStack.persistentContainer.viewContext);
            colobj.name = key
            colobj.hexValue = color
            CoreDataStack.saveContext()
        }
        
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



