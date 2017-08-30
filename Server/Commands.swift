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
    case toggleBW = "toggleBW"
    case addToRapid = "addToRapid"
}
