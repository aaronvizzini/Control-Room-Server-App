//
//  AppDelegate.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 14/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: -2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    /// Application did finish launching. Add the menu bar button and popover with its view controller. Also, start the event monitor which will handle the hiding of the popover when the user clicks outside of it.
    ///
    /// - Parameter aNotification: the notification
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let button:NSStatusBarButton = statusItem.button!
        button.image = NSImage(named: NSImage.Name(rawValue: "MenuBarIcon"))
        button.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
        button.action = #selector(self.togglePopover(sender:))
        
        popover.contentViewController = ServerViewController(nibName: NSNib.Name(rawValue: "ServerViewController"), bundle: nil)
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        
        let _ = popover.contentViewController?.view

        eventMonitor?.start()
        
        //A timer which calls a function checking if Lightroom is running
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            self.checkForLightroom(timer: timer)
        }
    }
    
    /// A timer will call this function. This function launches a background async utility task that checks to see if Lightroom is running, if Lightroom is not running the app closes. 
    ///
    /// - Parameter timer: the timer
    func checkForLightroom(timer:Timer) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            let runningApps:[NSRunningApplication] = NSWorkspace.shared.runningApplications
                
            var lightroomOpen = false
            for app in runningApps {
                if let identifier = app.bundleIdentifier {
                    if(identifier.contains("com.adobe.Lightroom")) {
                        lightroomOpen = true
                        break
                    }
                }
            }
                
            if(!lightroomOpen) {
               ClientServerManager.sharedInstance.appServer.stop()
               NSApplication.shared.terminate(self)
            }
        }
    }
    
    /// Application will terminate, disconnect the servers and clients
    ///
    /// - Parameter aNotification: the notification
    func applicationWillTerminate(_ aNotification: Notification) {
        SleepModeManager.allowSleep()
        ClientServerManager.sharedInstance.appServer.stop()
        ClientServerManager.sharedInstance.pluginReadClient.disconnect()
        ClientServerManager.sharedInstance.pluginWriteClient.disconnect()
    }

    /// Show the popover
    ///
    /// - Parameter sender: the sender
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    
    /// Close the popover
    ///
    /// - Parameter sender: the sender
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        
        eventMonitor?.stop()
    }
    
    
    /// Toggle the popover, closing or opening it
    ///
    /// - Parameter sender: the sender
    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    
    /// Technically we need to let the application accept opening with a file. The application does not do anything with the file other than accept it.
    /// This is done to allow the plugin in LR to open the application automatically. The LR SDK can only open a program if it is passing a file, thus we need this.
    ///
    /// - Parameters:
    ///   - sender: sender
    ///   - filename: filename
    /// - Returns: always returns true
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        return true
    }
}

