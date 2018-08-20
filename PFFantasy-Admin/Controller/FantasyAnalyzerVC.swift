//
//  FantasyAnalyzerVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 13/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import AppKit

class FantasyAnalyzerVC:NSViewController,NSTableViewDelegate,NSTableViewDataSource,CorrectCellDelegate{
    
    @IBOutlet weak var contentdesc: NSTextField!
    @IBOutlet weak var idlabel: NSTextField!
    @IBOutlet weak var proceedbutt: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var correcttableView: NSTableView!
    var availableQuestions:[Any]!
    var correctAns:Extras = [:]
    var allActualScores:Extras!
    var question:NSManagedObject?
    var contentToUpload:Extras!
    
    @IBOutlet weak var sprtsSegment: NSSegmentedControl!
    override func viewDidLoad() {
        availableQuestions = []
        allActualScores = [:]
        contentToUpload = [:]
        availableQuestions = CoreService.service.fetchRegular()
        tableView.delegate = self
        tableView.dataSource = self
        correcttableView.delegate = self
        correcttableView.dataSource = self
        contentdesc.isHidden = true
        
        
    }
    
    @IBAction func proceedPressed(_ sender: NSButton) {
        
        if contentdesc.isHidden {
            contentdesc.stringValue = contentToUpload.description
            proceedbutt.title = "Upload"
            contentdesc.isHidden = false
        }else{
            proceedbutt.title = "Verify"
            //Upload final thing
        
            Dataservice.service.postCorrectPick(data: contentToUpload) { (sucess, err, message) in
                if sucess{
                    alert(title: "SUCCESS", message: message)
                }else{
                    
                    alert(title: "ERROR", message: err.debugDescription);
                }
            }
            contentdesc.isHidden = true
        }
        
    }
    
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.tableView {
            return availableQuestions.count
        }else{
            if let rq = question as? RegularQuestions{
                return rq.getOptions().count
            }else if let bq = question as? BlazeQuestion{
                return bq.getOptions().count
            }
        }
        return 0
    }
    
    @IBAction func sortsChanged(_ sender: Any) {
        if let seg = sender as? NSSegmentedControl{
            if seg.selectedSegment == 0{
                availableQuestions.removeAll()
                availableQuestions = CoreService.service.fetchRegular()
                tableView.reloadData()
            }else if seg.selectedSegment == 1{
                availableQuestions.removeAll()
                availableQuestions = CoreService.service.fetchBlaze()
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if (tableView == self.tableView){
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "QID"), owner: self) as? NSTableCellView{
                if let q = availableQuestions[row] as? BlazeQuestion{
                    let labl = cell.viewWithTag(2) as! NSTextField
                    cell.textField?.stringValue = q.id!
                    let date = Date(timeIntervalSince1970: (TimeInterval(q.timestamp / 1000)))
                    labl.stringValue = stringFrom(date)
                }else if let q = availableQuestions[row] as? RegularQuestions{
                    cell.textField?.stringValue = q.id!
                    let labl = cell.viewWithTag(2) as! NSTextField
                    let date = Date(timeIntervalSince1970: (TimeInterval(q.timestamp / 1000)))
                    labl.stringValue = stringFrom(date)
                }
                return cell
             }
                
        }else if tableView == correcttableView{
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(describing: CorrectCells.self)), owner: self) as? CorrectCells{
                cell.delegate = self
                if question != nil{
                    if let rq = question as? RegularQuestions{
                        let id = "q\(row + 1)"
                        Swift.print(rq.getOptions())
                        let vals = rq.getOptions()[id] as! Extras
                        cell.configureView(question: (id, vals),type: CONTEST_REGULAR)
                    }else if let bq = question as? BlazeQuestion{
                        let id = "q\(row + 1)"
                        Swift.print(bq.getOptions())
                        let vals = bq.getOptions()[id] as! Extras
                        cell.configureView(question: (id, vals),type: CONTEST_BLAZE)
                    }
                }
                
                return cell
            }
        }
        
        return NSTableCellView()
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView == correcttableView {
            return 300
        }
        return 55
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = tableView.selectedRow
        if let sq = availableQuestions[index] as? RegularQuestions{
            idlabel.stringValue = sq.id!
            question = sq
        }else if let sq = availableQuestions[index] as? BlazeQuestion{
            idlabel.stringValue = sq.id!
            question = sq
        }
        correcttableView.reloadData()
    }
    
    func didFinishMakingChoice(id: String, optionName: String, actualPoint: Extras?) {
        
        if actualPoint != nil{
            correctAns[id] = optionName
           allActualScores[id] = actualPoint!
            Swift.print(allActualScores)
            let  rq = question! as! RegularQuestions
            if correctAns.count == rq.getOptions().count{
                let cor = CorrectPicks(context: CoreDataStack.persistentContainer.viewContext)
                cor.contestType = Int64(CONTEST_REGULAR)
                cor.id = rq.id!
                cor.correctOption = correctAns as NSObject
                cor.actuallPoints = allActualScores! as NSObject
                CoreDataStack.saveContext()
                contentToUpload = ["key":rq.id!,"data":[_PICK_NAMES:correctAns,_PICK_ACTUAL_SCORES:allActualScores]]
                proceedbutt.isEnabled = true
                Swift.print(contentToUpload)
                
            }
        }else{
            Swift.print(correctAns)
            correctAns[id] = optionName
            let bq = question as! BlazeQuestion
            if correctAns.count == bq.getOptions().count{
                let cor = CorrectPicks(context: CoreDataStack.persistentContainer.viewContext)
                cor.contestType = Int64(CONTEST_BLAZE)
                cor.id = bq.id!
                cor.correctOption = correctAns as NSObject
                
                CoreDataStack.saveContext()
                contentToUpload = ["key":bq.id!,"data":[_PICK_NAMES:correctAns,_PICK_ACTUAL_SCORES:allActualScores]]
                proceedbutt.isEnabled = true
                
            }
        }
    }
}
