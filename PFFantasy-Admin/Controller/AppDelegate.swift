//
//  AppDelegate.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/14/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Dataservice.service.getTransactions()
        //AuthenticationService.main.createRootUser(username: "root", password: "12shady");
        let alreadyRun = UserDefaults.standard.bool(forKey: FIRST_R)
        if !alreadyRun{
            UserDefaults.standard.set(1, forKey: QUESIDCOUNT)
            UserDefaults.standard.set(true, forKey: FIRST_R)
        }
        //Dataservice.service.postTofirebase(key: "Mandrake", data: ["hell":"Madness" as AnyObject], path: "http://localhost:3000/api/v1/NewUsers")
        // Insert code here to initialize your application
        //updatePlayersDB()
        
    }
    
    func updatePlayersDB(){
        Dataservice.service.getNewUsers { (success, err, data) in
            if(success && data != nil){
                if let data = data as? Extras{
                    CoreDatabase.service.createNewPlayer(largedata: data, h: { (success, keys) in
                        if (success){
                            //alert(title: "UPDATED", message: "New Player accounts succesfully indexed")
                            Dataservice.service.updateIndexed(data: keys, handler: { (suc, er, dat) in
                                if(suc){
                                    messageBox("UPDATED", message: "Succesfully updated Players at \(dat!)", firstOption: "DISMISS", secondOption: nil, thirdOption: nil, firstAction: {}, secondAction: {}, thirdAction: nil)
                                }else{
                                    messageBox("ERROR", message: "Failed to update Players at \(dat!)", firstOption: "DISMISS", secondOption: nil, thirdOption: nil, firstAction: nil, secondAction: nil, thirdAction: nil)
                                }
                            })
                            
                        }else{
                            alert(title: "GRAVE ERROR", message: "No Players to index")
                        }
                    })
                }else{
                    alert(title: "GRAVE ERROR", message:err?.localizedDescription ?? "Return data invalid")
                }
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    
        return CoreDataStack.persistentContainer.viewContext.undoManager
    }
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = CoreDataStack.persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }
    

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = CoreDataStack.persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }


}

