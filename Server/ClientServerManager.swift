//
//  ClientServerManager.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 20/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation


/// This singleton class holds the references to the single AppServer, PluginWriteClient, and PluginReadClient objects. This provides an easy way to reference the running server and clients and to use them for communications.
class ClientServerManager: NSObject {
    static let sharedInstance = ClientServerManager()
    var appServer: AppServer = AppServer()
    var pluginReadClient: PluginReadClient = PluginReadClient()
    var pluginWriteClient: PluginWriteClient = PluginWriteClient()
    
    /// Make the init private for this singleton
    private override init() {
        super.init()
    }
}
