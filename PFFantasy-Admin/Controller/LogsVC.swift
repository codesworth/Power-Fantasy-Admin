//
//  LogsVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/17/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class LogsVC: NSViewController {

    var allLogs:[Logs]!
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allLogs = []
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        allLogs = CoreService.service.fetchLogs()
        tableView.reloadData()
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(nil)
    }
}









extension LogsVC:NSTableViewDelegate, NSTableViewDataSource{
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return allLogs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let log = allLogs[row]
        if (tableColumn?.identifier)!.rawValue == "DateCol"{
            tableColumn?.headerCell.stringValue = "Date"
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView{
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yy HH:mm"
                //df.dateStyle = .short
                cell.textField?.stringValue = df.string(from: log.date!)
                return cell
            }
        }else if (tableColumn?.identifier)!.rawValue == "statementCol"{
            tableColumn?.title = "Action"
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "StateCell"), owner: self) as? NSTableCellView{
                cell.textField?.stringValue = log.statement!
                return cell
            }
        }else if (tableColumn?.identifier)!.rawValue == "AgentCol"{
            tableColumn?.title = "Agent"
            if let cell = tableView.makeView(withIdentifier:NSUserInterfaceItemIdentifier(rawValue: "AgentCell"), owner: self) as? NSTableCellView{
                cell.textField?.stringValue = log.agentID!
                return cell
            }
        }
        return NSTableCellView()
    }
    
}
