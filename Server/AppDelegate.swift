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

    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    
    /// Application did finish launching. Add the menu bar button and popover with its view controller. Also, start the event monitor which will handle the hiding of the popover when the user clicks outside of it.
    ///
    /// - Parameter aNotification: the notification
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "MenuBarIcon")
            button.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
            button.action = #selector(self.togglePopover(sender:))
        }
        
        popover.contentViewController = ServerViewController(nibName: "ServerViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
    }

    
    /// Application will terminate, disconnect the servers and clients
    ///
    /// - Parameter aNotification: the notification
    func applicationWillTerminate(_ aNotification: Notification) {
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
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

}

