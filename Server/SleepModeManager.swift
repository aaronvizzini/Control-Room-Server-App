//
//  SleepModeManager.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 14/09/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation

import IOKit
import IOKit.pwr_mgt

public class SleepModeManager {
    private static var preventAleepAssertionID: IOPMAssertionID = 0

    /// Prevents the computer from entering sleep mode (usually called when the app is connected)
    static func preventSleep() {
        let reasonForActivity = "Lightroom Interaction via Control Room" as CFString
        IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), reasonForActivity, &preventAleepAssertionID )
    }
    
    /// Allows the computer to enter sleep mode (usually called when the app is disconnected)
    static func allowSleep() {
        IOPMAssertionRelease(preventAleepAssertionID);
    }
}
