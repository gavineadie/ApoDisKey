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

//    public var comm: NWConnection
//
//    public func open(_ host: NWEndpoint) throws {
//
//    }
//
//    public func send(_ packet: Data) throws {
//
//    }
//
//    public func recv() throws -> Data {
//
//        Data()
//
//    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    let client: Client

    init() {
        client = Client("127.0.0.1", 19697)
        client.connection.start()

        setupReceive()
    }

    func sendPacket(_ packet: Data) {
        logger.log("<<< \(prettyString(packet))")
        client.connection.send(data: packet)
    }

    func setupReceive() {
        client.nwConnection.receive(minimumIncompleteLength: 1,
                                    maximumLength: 4) { (content, _, isComplete, error) in

            if let data = content, !data.isEmpty {
//              prettyPrint(data)
                if let _ = parseIoPacket(data) {
//                  logger.log("    channel \(triple.0, format: .octal(minDigits: 15) ): \(ZeroPadWord(triple.1, to: 15))")
                }
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

public struct Client {

    public var connection: Connection
    public let nwConnection: NWConnection

    public init(_ host: NWEndpoint.Host = "127.0.0.1",
                _ port: NWEndpoint.Port = 12345) {

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 10

        self.nwConnection = NWConnection(host: host,
                                         port: port,
                                         using: NWParameters(tls: nil, tcp: tcpOptions))
        
        self.connection = Connection(nwConnection: nwConnection)
    }

    func start() {
        self.connection.didStopCallback = self.didStopCallback(error:)
        self.connection.start()
    }

    func didStopCallback(error: Error?) {
        if error == nil {
            exit(EXIT_SUCCESS)
        } else {
            exit(EXIT_FAILURE)
        }
    }

}
