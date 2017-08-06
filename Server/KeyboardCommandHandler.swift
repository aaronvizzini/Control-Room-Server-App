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
        case .backward:
            vKey = 0x7B
        case .forward:
            vKey = 0x7C
        case .starZero:
            vKey = 0x1D
        case .starOne:
            vKey = 0x12
        case .starTwo:
            vKey = 0x13
        case .starThree:
            vKey = 0x14
        case .starFour:
            vKey = 0x15
        case .starFive:
            vKey = 0x17
        case .addToRapid:
            vKey = 0x0B
        case .flagSave:
            vKey = 0x23
        case .flagDelete:
            vKey = 0x07
        case .unflag:
            vKey = 0x20
        default:
            return
        }
        
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        
        if (vKey != nil) {
            let cmdd = CGEvent(keyboardEventSource: src, virtualKey: vKey!, keyDown: true)
            let cmdu = CGEvent(keyboardEventSource: src, virtualKey: vKey!, keyDown: false)
            
            let loc = CGEventTapLocation.cghidEventTap
            
            cmdd?.post(tap: loc)
            cmdu?.post(tap: loc)
        }
    }
}
