//
//  BLZQVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/17/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class BLZQVC: NSViewController {

    @IBOutlet weak var expDate: NSDatePicker!
    @IBOutlet weak var uploadQuestButt: FlatButton!
    @IBOutlet weak var questionID: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    var ques_ID:String!
    var choices:Extras!
    var json:Extras!
    var league:String!
    var numberOftemplates:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        choices = [:]
        json = [:]
        questionID.stringValue = ques_ID
        tableView.delegate = self
        tableView.dataSource = self
        uploadQuestButt.isEnabled = false
    }
    
    @IBAction func uploadPressed(_ sender: FlatButton) {
        Dataservice.service.uploadQuestion(questionID.stringValue, json) { (succes, err, extra) in
            if (succes){
                let blaze = BlazeQuestion(context: CoreDataStack.persistentContainer.viewContext)
                blaze.timestamp = self.expDate.dateValue.unixTimestamp()
                blaze.id = self.questionID.stringValue
                blaze.choice = self.choices! as NSObject
                blaze.league = self.league
                CoreDataStack.saveContext()
                incrementQNum()
                alert(title: "Question Set Succesfully Uploaded", message: extra)
                //choices.removeValue(forKey: _LEAGUE_TYPE)
                
            }else{
                alert(title: "Fatal Error", message: "There was a problem uploading Question Set")
            }
        };
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(nil)
    }
    
}





extension BLZQVC:NSTableViewDelegate, NSTableViewDataSource, BlazeQprotocol{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return numberOftemplates
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("BLZQCELLS"), owner: self) as? BLZQCELLS{
            cell.delegate = self
            cell.configure(index: row)
            return cell
        }
        
        return BLZQCELLS()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 310
    }
    
    
    func didFinishValidating(_ choice: Extras, _ number: String) {
        
        choices.updateValue(choice, forKey: "q\(number)")
        
        if choices.count == (numberOftemplates){
            uploadQuestButt.isEnabled = true
            let exp = expDate.dateValue.unixTimestamp()
            let json = [_TS: exp, _CHOICES:choices, _LEAGUE_TYPE:league] as [String : Any]
            self.json = json
            //log("\(json)")
            
        }
    }
}
