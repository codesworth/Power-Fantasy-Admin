//
//  RegularQVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 02/07/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class RegularQVC: NSViewController, RegularProtocol, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView:NSTableView!
    @IBOutlet weak var uploadquestButt: FlatButton!
    var numberOftemplates:Int!
    @IBOutlet weak var expirydate: NSDatePicker!
    var questionSet:Extras!
    var questionID:String!
    var league:String!
    @IBOutlet weak var newgenID: NSButton!
    @IBOutlet weak var quesidfiled: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadquestButt.isEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        quesidfiled.stringValue = questionID
        questionSet = [:]
    }
    
    
    @IBAction func uploadQuestPressed(_ sender: Any) {
        let ts = expirydate.dateValue.unixTimestamp();
        questionSet["ts"] = ts;
        questionSet[_LEAGUE_TYPE] = league
        Dataservice.service.uploadQuestion(questionID, questionSet) { (succes, err, extra) in
            if (succes){
                alert(title: "Question Set Succesfully Uploaded", message: extra)
                self.questionSet.removeValue(forKey: _LEAGUE_TYPE)
                self.questionSet.removeValue(forKey: "ts")
                let reg = RegularQuestions(context: CoreDataStack.persistentContainer.viewContext)
                reg.id = self.questionID
                reg.timestamp = ts
                reg.league = self.league
                reg.options = self.questionSet! as NSObject
                CoreDataStack.saveContext()
                incrementQNum()
            }else{
                alert(title: "Fatal Error", message: "There was a problem uploading Question Set")
            }
        };
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (numberOftemplates == nil){
            numberOftemplates = 8
        }
        return numberOftemplates
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(String(describing: RegularCells.self)), owner: self) as? RegularCells{
            cell.delegate = self
            cell.configureCell(index: row)
            return cell
        }
        
        return RegularCells()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 400
    }
    
    
    func didFinishValidating(_ choice: Extras, _ number: String) {
        questionSet[number] = choice
        
        if questionSet.count == numberOftemplates{
            uploadquestButt.isEnabled = true;
            Swift.print("This is the set: ", questionSet)
            
        }
    }
    
    
    @IBAction func generateIDPressed(_ sender: Any) {
        questionID = questionIDGenerators(type: .regular, league: league)
        quesidfiled.stringValue = questionID
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(nil)
    }
}

