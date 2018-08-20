//
//  CorrectCells.swift
//  PFFantasy-Admin
//
//  Created by Lord Codesworth on 14/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

protocol CorrectCellDelegate:class {
    func didFinishMakingChoice(id:String,optionName:String,actualPoint:Extras?)
}

class CorrectCells: NSTableCellView {

    @IBOutlet weak var submitButt: NSButtonCell!
    @IBOutlet weak var option1label: NSTextField!
    @IBOutlet weak var option2label: NSTextField!
    @IBOutlet weak var option3label: NSTextField!
    @IBOutlet weak var option4label: NSTextField!
    @IBOutlet weak var actualPointStack: NSStackView!
    @IBOutlet weak var questionField: NSTextField!
    @IBOutlet weak var quesNumber: NSTextField!
    var validatorText: NSTextField!
    weak var delegate:CorrectCellDelegate?
    var actuals:[String:Int]!
    var type:Int!
    @IBOutlet weak var segmentedFeld: NSSegmentedControl!
    var options:Array<Extras>!
    var opName:String?
    
    override func awakeFromNib() {
        validatorText = viewWithTag(11) as? NSTextField
        
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        opName = nil
        validatorText.stringValue = "NOT VALID"
    }
    
    func configureView(question:(String,Extras), type:Int){
        self.type = type
        quesNumber.stringValue = question.0.replacingOccurrences(of: "q", with: "")
        let ex = question.1
        if type == CONTEST_REGULAR{
            questionField.stringValue = ex[_QUESTION] as! String
            
            let options = ex[_OPTIONS] as! Array<Extras>
            
            self.options = options
            segmentedFeld.segmentCount = options.count
            if options.count == 2 {
                option3label.isHidden = true
                option4label.isHidden = true
                let fx = options.first!
                let fx2 = options[1]
                segmentedFeld.setLabel(fx[_OPTION_NAME] as! String, forSegment: 0)
                segmentedFeld.setLabel(fx2[_OPTION_NAME] as! String, forSegment: 1)
            }else if options.count == 3{
                option3label.isHidden = false
                option4label.isHidden = true
                let fx = options.first!
                let fx2 = options[1]
                let fx3 = options[2]
                segmentedFeld.setLabel(fx[_OPTION_NAME] as! String, forSegment: 0)
                segmentedFeld.setLabel(fx2[_OPTION_NAME] as! String, forSegment: 1)
                segmentedFeld.setLabel(fx3[_OPTION_NAME] as! String, forSegment: 2)
            }else if options.count == 4{
                option3label.isHidden = false
                option4label.isHidden = false
                let fx = options.first!
                let fx2 = options[1]
                let fx3 = options[2]
                let fx4 = options[3]
                segmentedFeld.setLabel(fx[_OPTION_NAME] as! String, forSegment: 0)
                segmentedFeld.setLabel(fx2[_OPTION_NAME] as! String, forSegment: 1)
                segmentedFeld.setLabel(fx3[_OPTION_NAME] as! String, forSegment: 2)
                segmentedFeld.setLabel(fx4[_OPTION_NAME] as! String, forSegment: 3)
            }
        }else if type == CONTEST_BLAZE{
            actualPointStack.isHidden = true
            questionField.stringValue = "\(ex[_HTEAM]!) VS \(ex[_ATEAM]!)"
            let segC = ex[_SEGTYPE] as! Int
            segmentedFeld.segmentCount = segC
            if segC == 2{
                segmentedFeld.setLabel(ex[_HTEAM] as! String, forSegment: 0)
                segmentedFeld.setLabel(ex[_ATEAM] as! String, forSegment: 1)
            }else if segC == 3{
                segmentedFeld.setLabel(ex[_HTEAM] as! String, forSegment: 0)
                segmentedFeld.setLabel(_DRAW, forSegment: 1)
                segmentedFeld.setLabel(ex[_ATEAM] as! String, forSegment: 2)
            }
        }
        
    }
    @IBAction func optionSelected(_ sender: NSSegmentedControl) {
        let selectedIndex = sender.selectedSegment
        opName = sender.label(forSegment: selectedIndex)
        
        
        
    }
    
    @IBAction func submitButtPressed(_ sender: NSButtonCell) {
        if (type == CONTEST_REGULAR){
            if (opName != nil && actualsGen()){
                delegate?.didFinishMakingChoice(id: "q\(quesNumber.stringValue)", optionName: opName!, actualPoint: actuals)
                validatorText.stringValue = "VALIDATED"
                validatorText.textColor = NSColor.green
            }else{
                validatorText.stringValue = "INVALID"
                validatorText.textColor = NSColor.red
            }
        }else if type == CONTEST_BLAZE && opName != nil{
            delegate?.didFinishMakingChoice(id:"q\(quesNumber.stringValue)" , optionName: opName!, actualPoint: nil)
            validatorText.stringValue = "VALIDATED"
            validatorText.textColor = NSColor.green
        }else{
            validatorText.stringValue = "INVALID"
            validatorText.textColor = NSColor.red
        }
    }
    func actualsGen()->Bool{
        actuals = [:]
        if options.count == 2 && option1label.stringValue != "" && option2label.stringValue != ""{
            let fx = options.first!
            let fx2 = options[1]
            let p1 = Int(option1label.stringValue); let p2 = Int(option2label.stringValue)
            if p1 != nil && p2 != nil{
                actuals![fx[_OPTION_NAME] as! String] = p1
                actuals![fx2[_OPTION_NAME] as! String] = p2
                return true
            }
        }else if options.count == 3{
            let fx = options.first!
            let fx2 = options[1]
            let fx3 = options[2]
            let p1 = Int(option1label.stringValue); let p2 = Int(option2label.stringValue)
            let p3 = Int(option3label.stringValue)
            if p1 != nil && p2 != nil && p3 != nil{
                actuals![fx[_OPTION_NAME] as! String] = p1
                actuals![fx2[_OPTION_NAME] as! String] = p2
                actuals![fx3[_OPTION_NAME] as! String] = p3
                return true
            }
        }else if options.count == 4{
            let fx = options.first!
            let fx2 = options[1]
            let fx3 = options[2]
            let fx4 = options[3]
            let p1 = Int(option1label.stringValue); let p2 = Int(option2label.stringValue)
            let p3 = Int(option3label.stringValue); let p4 = Int(option2label.stringValue)
            if p1 != nil && p2 != nil && p3 != nil && p4 != nil{
                actuals![fx[_OPTION_NAME] as! String] = p1
                actuals![fx2[_OPTION_NAME] as! String] = p2
                actuals![fx3[_OPTION_NAME] as! String] = p3
                actuals![fx4[_OPTION_NAME] as! String] = p4
                return true
            }
        }
      return false
    }
    
    
    
}
