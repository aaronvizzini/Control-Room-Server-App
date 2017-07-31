//
//  Commands.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation


/// An enum of the possible commands that relate to the possible keyboard commands that can be triggered. This relates to Lightroom shortcuts, principally for the library. 
enum Command: String {
    case forward = "forward"
    case backward = "backward"
    case flagSave = "flagSave"
    case flagDelete = "flagDelete"
    case unflag = "unflag"
    case addToRapid = "addToRapid"
    case starZero = "starZero"
    case starOne = "starOne"
    case starTwo = "starTwo"
    case starThree = "starThree"
    case starFour = "starFour"
    case starFive = "starFive"
    case library = "library"
    case develop = "develop"
    case connected = "connected"
    case requestPresets = "requestPresets"
}
