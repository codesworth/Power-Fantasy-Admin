//
//  PreferenceVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/16/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class PreferenceVC: NSViewController {

    @IBOutlet weak var cancel: FlatButton!
    @IBOutlet weak var addbutt: FlatButton!
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var conPass: NSSecureTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var adduserButt: FlatButton!
    var editingMode = false
    var selectedAdmin:Admins!
    var admins:[Admins]!
        @IBOutlet weak var viewLogsbutt: FlatButton!
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        admins = []
        tableView.delegate = self
        tableView.dataSource = self
        admins = CoreService.service.fetchAdmins()
        DECLAREDOMAIN(domain: LoggerDomain.preferencePain)
        Log.log(statement: "Prefernce Pane launched", domain: nil)
        stackView.isHidden = true
        adduserButt.isHidden = true
        let accessLevel = AccessLevel(rawValue: ACCESS_LEVEL)
        if accessLevel != nil{
            if accessLevel! == .root{
                adduserButt.isHidden = false
                
            }else if accessLevel! == .user{
                
            }
        }
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if ACCESS_LEVEL == AccessLevel.noAccess.rawValue{
            self.dismiss(nil)
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addUserPressed(_ sender: FlatButton){
        Log.log(statement: "Attempted creation of Admin user account", domain: nil)
        stackView.isHidden = false
        editingMode = false
        
    }
    

    @IBAction func viewLogsPressed(_ sender: FlatButton) {
        Log.log(statement: "Attempted Viewing Amin Logs", domain: nil)
    }
    
    @IBAction func confirm(_ sender: FlatButton) {
        if editingMode{
            if username.stringValue.count > 6 && password.stringValue.count > 6 && password.stringValue == conPass.stringValue{
                let res = AuthenticationService.main.updatePasswordFor(username:selectedAdmin.username! , oldpass: username.stringValue, newPass: password.stringValue)
                if res.1{
                    alert(title: "Success", message: "Password succesfully changed")
                }else{
                    Log.log(statement: "Failed in attempt to change \(selectedAdmin.username!) password", domain: nil)
                }
            }else{
                alert(title: "Auth Error", message: "New Passwords dont match")
                Log.log(statement: "Error in attempt to change \(selectedAdmin.username!) password", domain: nil)
            }
        }else{
            if username.stringValue.count > 3  && password.stringValue.count > 6 && password.stringValue == conPass.stringValue {
                AuthenticationService.main.createUser(username: username.stringValue, password: password.stringValue)
                log("\(username.stringValue), \(password.stringValue), \(conPass.stringValue)")
                let ad = Admins(context: CoreDataStack.persistentContainer.viewContext)
                ad.username = username.stringValue
                ad.accessLevel = AccessLevel.user.rawValue
                CoreDataStack.saveContext()
                alert(title: "Admin User Added", message: "Admin user account created and added")
                Log.log(statement: "Admin User account created and added succesfully", domain: nil)
                tableView.reloadData()
            }else{
                //alert(title: "Invalid Data Fields", message: "Please enter a valid username and password for Admin account")
                Log.log(statement: "Failed attempt to create Admin account", domain: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: FlatButton) {
    }
}


extension PreferenceVC: NSTableViewDelegate,NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return admins.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let admin = admins[row]
        if let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Admins"), owner: self) as? NSTableCellView{
            view.textField?.stringValue = admin.username!
            return view
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectedAdmin = admins[tableView.selectedRow]
        username.stringValue = selectedAdmin.username!
        editingMode = true
        stackView.isHidden = false
        addbutt.title = "Change Password"
        username.placeholderString = "Old Password"
        password.placeholderString = "New Password"
        

        
    }
}



