//
//  QuesHelperVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/17/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class QuesHelperVC: NSViewController {

    @IBOutlet weak var confirm: FlatButton!
    @IBOutlet weak var numberBlaze: NSTextField!
    @IBOutlet weak var questiontypw: NSComboBox!
    @IBOutlet weak var leagueCom: NSComboBox!
    @IBOutlet weak var backbutton: FlatButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        confirm.isEnabled = false
        numberBlaze.isEnabled = false
        // Do view setup here.
    }
    
    @IBAction func backbuttonPressed(_ sender: Any) {
        self.dismiss(nil);
    }
    @IBAction func selectionChanged(_ sender: NSComboBox) {
        if sender.stringValue == "Regular"{
            confirm.isEnabled = true
            numberBlaze.isEnabled = true
        }else if sender.stringValue == "Blaze"{
            numberBlaze.isEnabled = true
            confirm.isEnabled = true
        }
        
    }
    @IBAction func confirmPressed(_ sender: Any) {
         let number:Int? = Int(numberBlaze.stringValue)
        let league = leagueCom.stringValue
        if questiontypw.stringValue == "Regular"{
            let id = questionIDGenerators(type: .regular, league: leagueCom.stringValue)
            performSegue(withIdentifier: NSStoryboardSegue.Identifier("Regular"), sender: (id,number,league))
            
            //passwith segue
        }else if questiontypw.stringValue == "Blaze" && number != nil{
            let id = questionIDGenerators(type: .blaze, league: leagueCom.stringValue)
            performSegue(withIdentifier: NSStoryboardSegue.Identifier("BlazeQuestions"), sender: (id,number,league))
            //dismiss(nil)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == NSStoryboardSegue.Identifier("BlazeQuestions"){
            if let dest = segue.destinationController as? BLZQVC{
                if let num = sender as? (String, Int, String){
                    dest.numberOftemplates = num.1
                    dest.ques_ID = num.0
                    dest.league = num.2
                }
            }
        }else if segue.identifier ==  NSStoryboardSegue.Identifier("Regular"){
            if let dest = segue.destinationController as? RegularQVC{
                if let num = sender as? (String, Int?,String){
                    dest.numberOftemplates = num.1
                    dest.questionID = num.0
                    dest.league = num.2
                }
            }

        }
    }
}
