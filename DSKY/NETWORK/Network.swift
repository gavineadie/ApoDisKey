//
//  Network.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/15/24.
//

import Foundation
import Network

struct Network {

    let connection: NWConnection
    let didStopCallback: ((Error?) -> Void)?

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 12345) {

        self.didStopCallback = { error in
            exit( error == nil ? EXIT_SUCCESS : EXIT_SUCCESS )
        }

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
                DisKeyModel.shared.netFailCode = error.errorCode
                DisKeyModel.shared.statusFooter = error.localizedDescription
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
        if let didStopCallback = self.didStopCallback {
            didStopCallback(error)
        }
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
                _ = parseIoPacket(data)

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
}

