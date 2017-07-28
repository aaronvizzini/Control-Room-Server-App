//
//  ServerViewController.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 14/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Cocoa

class ServerViewController: NSViewController, AppServerDelegate, PluginReadClientDelegate, PluginWriteClientDelegate {

    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var ipLabel: NSTextField!
    @IBOutlet weak var appConnectedLabel: NSTextField!
    @IBOutlet weak var lightroomStatusLabel: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    
    private var pluginReadClientConnected = false
    private var pluginWriteClientConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClientServerManager.sharedInstance.appServer.delegate = self
        ClientServerManager.sharedInstance.pluginWriteClient.delegate = self
        ClientServerManager.sharedInstance.pluginReadClient.delegate = self
    }
    
    @IBAction func quitServerApp(_ sender: AnyObject) {
        ClientServerManager.sharedInstance.appServer.stop()
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func startStopServer(_ sender: AnyObject) {
        if(!ClientServerManager.sharedInstance.appServer.isRunning) {
            self.startStopButton.title = NSLocalizedString("Stop Server", comment: "")
            ClientServerManager.sharedInstance.appServer.start()
            ClientServerManager.sharedInstance.pluginReadClient.connectSocket()
            ClientServerManager.sharedInstance.pluginWriteClient.connectSocket()
        } else {
            ClientServerManager.sharedInstance.appServer.stop()
            ClientServerManager.sharedInstance.pluginReadClient.disconnect()
            ClientServerManager.sharedInstance.pluginWriteClient.disconnect()
            self.startStopButton.title = NSLocalizedString("Start Server", comment: "")
        }
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        
        if(getifaddrs(&ifaddr) == 0) {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                let addr = ptr?.pointee.ifa_addr.pointee
                
                if(flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if(addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6)) {
                        
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if(getnameinfo(ptr?.pointee.ifa_addr, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.init(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    /// App server delegate method called when the server did finish starting. Updates the UI accordingly.
    func serverDidFinishStarting() {
        self.statusLabel.stringValue = NSLocalizedString("ON", comment: "")
        self.ipLabel.stringValue = getIFAddresses()[1]
    }
    
    /// App server delegate method called when the server did finish stopping. Updates the UI accordingly.
    func serverDidFinishStopping() {
        self.statusLabel.stringValue = NSLocalizedString("OFF", comment: "")
    }
    
    /// App server delegate method called when the server did accept a new socket at the given host. Updates the UI accordingly.
    ///
    /// - Parameter host: the host
    func serverDidAcceptNewSocketAt(host: String) {
        self.appConnectedLabel.stringValue = host
    }
    
    /// App server delegate method called when the socket did disconnect. Updates the UI accordingly.
    func serverSocketDidDisconnect() {
        self.appConnectedLabel.stringValue = NSLocalizedString("None", comment: "")
    }
    
    /// Write client delegate method called when the client connects with the LR plugin
    func writeClientDidConnect() {
        pluginWriteClientConnected = true

        if(pluginWriteClientConnected && pluginWriteClientConnected) {
            self.lightroomStatusLabel.stringValue = NSLocalizedString("ON", comment: "")
        } else {
            self.lightroomStatusLabel.stringValue = NSLocalizedString("OFF", comment: "")
        }
    }
    
    /// Write client delegate method called when the client disconnects with the LR plugin
    func writeClientDidDisconnect() {
        self.lightroomStatusLabel.stringValue = NSLocalizedString("OFF", comment: "")
        pluginWriteClientConnected = false
    }
    
    /// Read client delegate method called when the client connects with the LR plugin
    func readClientDidConnect() {
        pluginReadClientConnected = true

        if(pluginReadClientConnected && pluginReadClientConnected) {
            self.lightroomStatusLabel.stringValue = NSLocalizedString("ON", comment: "")
            print("readClientDidConnect")
        } else {
            self.lightroomStatusLabel.stringValue = NSLocalizedString("OFF", comment: "")
        }
    }
    
    /// Read client delegate method called when the client disconnects with the LR plugin
    func readClientDidDisconnect() {
        self.lightroomStatusLabel.stringValue = NSLocalizedString("OFF", comment: "")
        pluginReadClientConnected = false
    }
}
