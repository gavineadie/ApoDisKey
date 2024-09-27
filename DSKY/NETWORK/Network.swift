//
//  Network.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/15/24.
//

import Foundation
import Network

struct Network : Sendable {

    let connection: NWConnection
//    let didStopCallback: (Error?) -> Void

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 12345) {

//        self.didStopCallback = { error in
//            exit( error == nil ? EXIT_SUCCESS : EXIT_SUCCESS )
//        }

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 10

        self.connection = NWConnection(host: NWEndpoint.Host(host),
                                       port: NWEndpoint.Port(rawValue: port)!,
                                       using: NWParameters(tls: nil,
                                                           tcp: tcpOptions))

        self.connection.stateUpdateHandler = self.stateDidChange(to:)
        self.connection.start(queue: .main)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
            case .setup:
                print("connection .setup")
            case .waiting(let error):
                print("connection .waiting: \(error.localizedDescription)")
            case .preparing:
                print("connection .preparing")
            case .ready:
                print("connection .ready")
            case .failed(let error):
                print("connection .failed")
                self.connectionDidFail(error: error)
            case .cancelled:
                print("connection .cancelled")
            default:
                print("connection .default")
        }
    }

    private func connectionDidFail(error: Error) {
        print("connection did fail, error: \(error)")
        self.stop(error: error)
    }

    private func stop(error: Error?) {
        print("... \(#function)")
        self.connection.stateUpdateHandler = nil
        self.connection.cancel()
//        self.didStopCallback(error)
    }

    public func send(data: Data) {
        self.connection.send(content: data,
                             completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
        }))
    }

    func recv() {
        connection.receive(minimumIncompleteLength: 1,
                           maximumLength: 4) { (content, _, connectionEnded, error) in

            if let data = content, !data.isEmpty {
                if let (channel, action, _) = parseIoPacket(data) {
                    channelAction(channel, action)
                }

                recv()
            }

            if connectionEnded {
                print("... \(#function) - connection did end")
            } else if let error = error {
                print(".. \(#function) - connection did fail, error: \(error)")
                self.stop(error: error)
            }
        }
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Converts a 4-byte yaAGC channel i/o packet to integer channel-number and value ..                ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ bytes: 00pppppp 01pppddd 10dddddd 11dddddd                                                       ┆
  ┆        ^^       ^^       ^^       ^^            packet validation bits                           ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆           ppppppppp is the 9-bit channel               ddddddddddddddd is the 15-bit value.      ┆
  ┆                                                                                                  ┆
  ┆            00pppppp                                           01pppddd                           ┆
  ┆             << 3                                          << 12                                  ┆
  ┆    0000000pppppp---                                    ddd------------                           ┆
  ┆                                                                                                  ┆
  ┆            01pppddd                                           10dddddd                           ┆
  ┆                >> 3                                             << 6                             ┆
  ┆    0000000------ppp                                    ---dddddd------                           ┆
  ┆                                                                                                  ┆
  ┆                   u is the "u-bit"                            11dddddd                           ┆
  ┆                                                                                                  ┆
  ┆            00pppppp                                    ---------dddddd                           ┆
  ┆                                                                                                  ┆
  ┆            --u-----                                                                              ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

/// This function is the reverse of FormIoPacket:
/// A 4-byte packet representing yaAGC channel i/o can be converted to an integer channel-number and value.
    func parseIoPacket (_ data: Data) -> (UInt16, UInt16, Bool)? {
        
        guard data.count == 4 else {
            logger.log("\(#function): not four bytes")
            return nil
        }
        
        let byte = [UInt8](data)
        
        if ((byte[0] == 0xff) &&
            (byte[1] == 0xff) &&
            (byte[2] == 0xff) &&
            (byte[3] == 0xff)) { return nil }
        
        if (byte[0] / 64) != 0 || (byte[1] / 64) != 1 ||
            (byte[2] / 64) != 2 || (byte[3] / 64) != 3 {
            logger.log("\(#function): prefix bits wrong [\(prettyString(data))]")
            return nil
        }
        
        let channel: UInt16 = UInt16(byte[0] & UInt8(0b00111111)) << 3 |
        UInt16(byte[1] & UInt8(0b00111000)) >> 3
        
        let value: UInt16 =   UInt16(byte[1] & UInt8(0b00000111)) << 12 |
        UInt16(byte[2] & UInt8(0b00111111)) << 6 |
        UInt16(byte[3] & UInt8(0b00111111))
        
        return (channel, value, (byte[0] & 0b00100000) > 0)
    }

}
