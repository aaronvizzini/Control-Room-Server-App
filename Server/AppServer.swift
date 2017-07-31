//
//  Server.swift
//  Control Room Server
//
//  Created by Aaron Vizzini on 15/07/2017.
//  Copyright © 2017 Aaron Vizzini. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

protocol AppServerDelegate: class {
    func serverDidFinishStarting()
    func serverDidFinishStopping()
    func serverDidAcceptNewSocketAt(host: String)
    func serverSocketDidDisconnect()
}


/// The App Server handles communication between the iOS App and this app. Data being received from the iOS app will be then passed onto the LR plugin via the PluginWriteClient class which handles writing to the plugin (a seperate connection). The PluginReadClient receives data from the plugin and then passes it onto the iOS app via the App Server. 
class AppServer: NSObject, GCDAsyncSocketDelegate {
    var listenSocket: GCDAsyncSocket = GCDAsyncSocket(delegate: self as? GCDAsyncSocketDelegate, delegateQueue: DispatchQueue.main)
    var connectedSockets: [GCDAsyncSocket] = []
    weak var delegate: AppServerDelegate?
    var isRunning: Bool = false

    override init() {
        super.init()
        listenSocket.delegate = self as GCDAsyncSocketDelegate
    }
    
    
    /// Start the app server
    public func start() {
        if(!isRunning) {
            let port:Int = 54345
            
            do {
                try listenSocket.accept(onPort: UInt16(port))
            } catch let error {
                print(error)
                return
            }
            
            listenSocket.perform({
                var on: UInt32 = 1;
                if setsockopt(self.listenSocket.socketFD(), SOL_SOCKET, TCP_NODELAY, &on, socklen_t(MemoryLayout.size(ofValue: on))) == -1 { }
                
            })
            
            self.delegate?.serverDidFinishStarting()
            isRunning = true
        }
    }
    
    
    /// Stop the app server
    public func stop() {
        if(isRunning) {
            listenSocket.disconnect()
            
            //  let lockQueue = DispatchQueue("com.test.LockQueue", nil)
            //   lockQueue.sync() {
            for socket in connectedSockets {
                socket.disconnect()
            }
            //   }
            
            self.delegate?.serverDidFinishStopping()
            isRunning = false;
        }
    }
    
    
    /// Called when the server did accept a new socket connection
    ///
    /// - Parameters:
    ///   - sock: the current socket
    ///   - newSocket: the new socket
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        //  let lockQueue = DispatchQueue("com.test.LockQueue", nil)
        //   lockQueue.sync() {
        connectedSockets.append(newSocket)
        //}
        
        print("Did accept new socket on app server")
        
        let host: String = newSocket.connectedHost!
        
        DispatchQueue.main.async {
            autoreleasepool {
                self.delegate?.serverDidAcceptNewSocketAt(host: host)
            }
        }
        
        newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    }
    
    
    /// Called when data has been written to the socket
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - tag: the tag relating to this operation
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        if(tag == 1) {
            sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
        }
    }
    
    
    /// Called when data has been read from the socket
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - data: the data being read
    ///   - tag: the tag relating to this operation
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        DispatchQueue.main.async {
            autoreleasepool {
                let strData: Data = data.subdata(in: 0..<data.count - 2)
                let msg: String = String(data: strData, encoding: String.Encoding.utf8)!
                var parts: [String] = msg.characters.split{$0 == ":"}.map(String.init)
                
                print("App server did read: \(msg)")
                
                if(parts.count >= 2) {
                    if(parts[0] == "CMD"){
                        let cmd = Command(rawValue: parts[1])!
                    
                        if (cmd != Command.library && cmd != Command.develop && cmd != Command.connected && cmd != Command.requestPresets) {
                            KeyboardCommandHandler.sharedInstance.handleKeyboardCommand(cmd: cmd)
                        } else {
                            ClientServerManager.sharedInstance.pluginWriteClient.send(command: cmd)
                        }
                    } else if(parts[0] == "ValueType") {
                        parts = parts[1].characters.split{$0 == ","}.map(String.init)
                        
                        ClientServerManager.sharedInstance.pluginWriteClient.send(value: parts[1], forValueType: parts[0])
                    } else if(parts[0] == "Preset"){
                        let preset = parts[1]
                
                        ClientServerManager.sharedInstance.pluginWriteClient.send(preset: preset)
                    }
                }
                
                sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
                print(msg)
            }
        }
        
       // sock.write(data, withTimeout: -1, tag: 1)
    }
    
    
    /// Called when a socket does disconnect from the server
    ///
    /// - Parameters:
    ///   - sock: the socket
    ///   - err: the possible error relating to this disconnection
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if(sock != listenSocket) {
            DispatchQueue.main.async {
                autoreleasepool {
                    print("Client disconnected on app server")
                    self.delegate?.serverSocketDidDisconnect()
                }
            }
            
            //@synchronized(connectedSockets)
            // {
            connectedSockets.remove(at: connectedSockets.index(of: sock)!)
            // }
        }
    }
    
    
    /// Function used as a helper function to send data from the server to the connected client iOS app
    ///
    /// - Parameters:
    ///   - value: the value of the development parameter
    ///   - valueType: the development parameter iteself
    func send(value: Float, forValueType valueType: ValueType) {
        let cmdStr = "ValueType:\(valueType),\(value)"
        send(string: cmdStr)
    }
    
    /// Sends a range for either the temp/tint that should be reflected in the app's UI. LR has dynamic ranges for the tint and temp that changes based on the photo.
    ///
    /// - Parameters:
    ///   - rangeFor: the type of range (TempRange or TintRange)
    ///   - min: min value string
    ///   - max: max value string
    func send(rangeFor: String, min: String, max: String) {
        let cmdStr = "\(rangeFor):\(min),\(max)"
        send(string: cmdStr)
    }
    
    /// Sends a development preset and its folder to the App.
    ///
    /// - Parameters:
    ///   - presetFolder: the preset's folder
    ///   - presetName: the preset's name
    ///   - presetUuid: the preset's Uuid
    func send(presetFolder: String, presetName: String, presetUuid: String) {
        let cmdStr = "Preset:\(presetFolder),\(presetName),\(presetUuid)"
        send(string: cmdStr)
    }
    
    /// Sends a string message from the server to the connected client iOS app in the correctly formatted fashion
    ///
    /// - Parameter string: the string message to send
    func send(string: String) {
        if(connectedSockets.count > 0) {
            let formattedString = "\(string)\r\n"
            let data = formattedString.data(using: String.Encoding.utf8)
            
            print("Sending: \(formattedString)")

            self.connectedSockets[0].write(data!, withTimeout: 20.0, tag: 1)
        }
    }
}
