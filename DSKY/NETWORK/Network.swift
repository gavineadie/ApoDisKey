//
//  Network.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/15/24.
//

import Foundation
import Network

struct Network : Sendable{

    let connection: NWConnection
    let didStopCallback: @Sendable (Error?) -> Void

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

    @Sendable private func stateDidChange(to state: NWConnection.State) {
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

}

extension NWConnection {
    
    func rawSend(data: Data?) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            send(content: data, completion: .contentProcessed { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            })
        }
    }
    
    func rawReceive(length: Int) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            receive(minimumIncompleteLength: length,
                    maximumLength: length) { data, _, connectionEnded, error in
                if connectionEnded {
                    print("... \(#function) - connection did end")
                }
                if let error {
                    precondition(data == nil)
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data!)
                }
            }
        }
    }

}
