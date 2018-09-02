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
        setup()
        
        DECLAREDOMAIN(domain: LoggerDomain.startup)
        
    }
    
    
    func setup(){
        dividerview.wantsLayer = true
        loginButt.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        loginButt.layer?.cornerRadius = 20
        loginButt.layer?.backgroundColor = NSColor(calibratedRed: 10/255, green: 201/255, blue: 217/255, alpha: 1).cgColor
        dividerview.layer?.backgroundColor = NSColor(calibratedRed: 10/255, green: 201/255, blue: 217/255, alpha: 1).cgColor
    }
    
    
    @IBAction func logInPressed(_ sender: NSButton) {
        Log.log(statement: "Attempted Log In", domain: nil)
        
        let u = useridtxt.stringValue; let p = passwrdtext.stringValue
        if u != "" && p != ""{
            var access = AuthenticationService.main.retrieveAccount(username: u, password: p)
            if access.0{
                AgentID = u
                ACCESS_LEVEL = AccessLevel.root.rawValue
                Log.log(statement: "Successful log In with root priveldge", domain: nil)
                log("Logged In as \(access.1!.rawValue)")
                self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("loggedIn"), sender: nil)

            }else{
                access = AuthenticationService.main.retrieveUserAccount(username: u, password: p)
                if access.0{
                    AgentID = u
                    self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("loggedIn"), sender: nil)
                    
                    ACCESS_LEVEL = AccessLevel.user.rawValue
                    Log.log(statement: "Successful log In", domain: nil)
                    log("Logged In as \(AgentID)")
                }else{
                   alert(title: "Authentication Error", message: "Wrong User ID and Password")
                    Log.log(statement: "Failed Log In attempt", domain: nil)
                }
            }
        }else{
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.informativeText = "Please enter user ID and Password"
            alert.messageText = "Invalid User ID and password Fields"
            alert.runModal()
        }
    }
    
    let sssss = "AMSHAHAH /23393993"
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
    }
    
}
