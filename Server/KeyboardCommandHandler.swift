//
//  KeyboardCommandHandler.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation


/// A singleton class used to trigger keyboard commands. Keyboard commands that are shortcuts for Lightroom functionality
class KeyboardCommandHandler: NSObject {
    static let sharedInstance = KeyboardCommandHandler()
    
    
    /// Make the init private for this singleton
    private override init() {
        super.init()
    }
    
    
    /// Receives a command and based on this command triggers a keyboard event.
    ///
    /// - Parameter cmd: the command that relates to the desired keyboard event.
    func handleKeyboardCommand(cmd: Command) {
        var vKey:CGKeyCode?
        
        switch cmd {
         
        case .toggleBW:
            vKey = 0x09
        case .addToRapid:
            vKey = 0x0B
        }
        
        if (vKey != nil) {
            let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

            let cmdd = CGEvent(keyboardEventSource: src, virtualKey: vKey!, keyDown: true)
            let cmdu = CGEvent(keyboardEventSource: src, virtualKey: vKey!, keyDown: false)
            
            let loc = CGEventTapLocation.cghidEventTap
            
            cmdd?.post(tap: loc)
            cmdu?.post(tap: loc)
        }
    }
}
