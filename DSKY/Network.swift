//
//  Network.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/15/24.
//

import Foundation
import Network
import TCPLib

struct Network {
    
    let client: Client
    
    init() {
        client = Client("127.0.0.1", 19697)
        client.connection.start()
        
        setupReceive()
    }
    
    func setupReceive() {
        client.nwConnection.receive(minimumIncompleteLength: 1,
                                    maximumLength: 4) { (content, _, isComplete, error) in
            
            if let data = content, !data.isEmpty {
                print("data from AGC: \(data as NSData)")
            }
            if isComplete {
                client.connection.connectionDidEnd()
            } else if let error = error {
                client.connection.connectionDidFail(error: error)
            }  else {
                setupReceive()
            }
        }
    }
}
