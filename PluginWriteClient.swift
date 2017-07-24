//
//  PluginWriteClient.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


/// The PluginWriteClient handles sending data to the LR Plugin. It can only send data as the LR Plugin requires seperate ports for sending and receiving data. The PluginWriteClient is used by the AppServer when the iOS app wishes to send data to the plugin.
class PluginWriteClient: NSObject, GCDAsyncSocketDelegate {
    private var mSocket: GCDAsyncSocket?
    
    
    /// Connect the socket, making a connection to the LR plugin for writing.
    func connectSocket() {
        do {
            print("Plugin Write Client connecing to LR Plugin")
            
            let mSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
            try mSocket.connect(toHost: "localhost", onPort: 54346)
            
            mSocket.perform({
                var on: UInt32 = 1;
                if setsockopt(mSocket.socketFD(), SOL_SOCKET, TCP_NODELAY, &on, socklen_t(MemoryLayout.size(ofValue: on))) == -1 { }
            })
            
        } catch let error {
            print(error)
        }
    }
    
    
    /// Determine if a connection has been made
    ///
    /// - Returns: whether or not the socket is connected.
    func isConnected() -> Bool {
        return (mSocket != nil && mSocket!.isConnected)
    }
    
    
    /// Disconnect the socket
    func disconnect() {
        mSocket?.disconnect()
    }
    
    
    /// Called when the socket did make a connection
    ///
    /// - Parameters:
    ///   - socket: the socket
    ///   - host: the host connecting to
    ///   - p: the port connecting with
    func socket(_ socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16) {
        mSocket = socket
        print("Plugin Write Client did connect")
    }
    
    
    /// Called when data has been written to the socket
    ///
    /// - Parameters:
    ///   - socket: the socket
    ///   - tag: the tag relating to this operation
    func socket(_ socket: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        if(tag == 1) {
            socket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        }
    }
    
    
    /// Called when the socket did read data. This will never be called as the LR plugin writes to a different socket.
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - data: the data
    ///   - tag: the tag relating to this operation
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        DispatchQueue.main.async {
            autoreleasepool {

            }
        }
    }
    
    /// Called when the socket disconnects
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - err: the possible error relating to this disconnection
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("Plugin Write Client did disconnect")
    }
    
    /// Sends a command message from the server to the  LRplugin in the correctly formatted fashion
    ///
    /// - Parameter string: the string message to send
    func send(command: Command) {
        let cmdStr = "CMD:\(command)"
        send(string: cmdStr)
    }
    
    /// Sends an updated value/value message from the server to the LRplugin in the correctly formatted fashion
    ///
    /// - Parameters:
    ///   - value: the value of the development parameter
    ///   - valueType: the development parameter iteself
    func send(value: String, forValueType valueType: String) {
        let cmdStr = "ValueType:\(valueType),\(value)"
        send(string: cmdStr)
    }
    
    /// Sends a string message from the server to the LR plugin in the correctly formatted fashion
    ///
    /// - Parameter string: the string message to send
    func send(string: String) {
        if(mSocket != nil && mSocket!.isConnected) {
            
            print("Plugin Write Sending: \(string)")
            
            let formattedString = "\(string)\r\n"
            let data = formattedString.data(using: String.Encoding.utf8)
            mSocket?.write(data!, withTimeout: 20.0, tag: 1)
        } else {
            self.connectSocket()
        }
    }
}
