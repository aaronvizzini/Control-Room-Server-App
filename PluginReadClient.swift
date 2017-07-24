//
//  PluginReadClient.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation
import CocoaAsyncSocket


/// The PluginReadClient handles reading data that is sent by the LR plugin. It can only read data as the LR Plugin requires seperate ports for sending and receiving data. Data the is read in from the plugin is sent to the iOS app via the AppServer.
class PluginReadClient: NSObject, GCDAsyncSocketDelegate {
    private var mSocket: GCDAsyncSocket?
    
    
    /// Called to connect the socket to the plugin
    func connectSocket() {
        do {
            print("Plugin Read Client connecing to LR Plugin")
            
            let mSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
            try mSocket.connect(toHost: "localhost", onPort: 54347)
            
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
        socket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        print("Plugin Read Client did connect")
    }
    
    /// Called when data has been written to the socket. Goes unused as writing to the LR plugin can only occur via the PluginWriteClient
    ///
    /// - Parameters:
    ///   - socket: the socket
    ///   - tag: the tag relating to this operation
    func socket(_ socket: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        if(tag == 1) {
            socket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        }
    }
    
    /// Called when the socket did read data. Coming in from the plugin and is eventually passed along to the iOS app via the AppServer via the handle function
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - data: the data
    ///   - tag: the tag relating to this operation
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        DispatchQueue.main.async {
            autoreleasepool {
                let strData: Data = data.subdata(in: 0..<data.count - 2)
                let msg: String = String(data: strData, encoding: String.Encoding.utf8)!
                var parts: [String] = msg.characters.split{$0 == ":"}.map(String.init)
                
                print("Plugin Read Client did read: \(msg)")
                
                if(parts[0] == "ValueType") {
                    parts = parts[1].characters.split{$0 == ","}.map(String.init)
                    if(parts.count == 2) {
                        self.handle(value: Float(parts[1])!, forValueType: ValueType(rawValue: parts[0])!)
                    }
                }
                
            }
        }
        
        sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    }
    
    /// Called when the socket disconnects
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - err: the possible error relating to this disconnection
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("Plugin Read Client did disconnect")
    }
    
    
    /// Called when a new value is being received from the LR plugin this value is when one of the development parameters is changed and it must be passed onto the iOS app.
    ///
    /// - Parameters:
    ///   - value: the value of the development parameter
    ///   - valueType: the development parameter iteself
    private func handle(value: Float, forValueType valueType: ValueType) {
        ClientServerManager.sharedInstance.appServer.send(value: value, forValueType: valueType)
    }
}
