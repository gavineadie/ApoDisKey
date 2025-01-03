//
//  Network.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul15/24 (copyright 2024-25)
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable switch_case_alignment

import Foundation
@preconcurrency import Network

struct Network: Sendable {

    let connection: NWConnection
    let didStopCallback: @Sendable (Error?) -> Void

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 19697, start: Bool = false) {

        self.didStopCallback = { error in
            exit( error == nil ? EXIT_SUCCESS : EXIT_SUCCESS )
        }

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 30

        self.connection = NWConnection(host: NWEndpoint.Host(host),
                                       port: NWEndpoint.Port(rawValue: port)!,
                                       using: NWParameters(tls: nil,
                                                           tcp: tcpOptions))
        if start {
            self.connection.stateUpdateHandler = self.stateDidChange(to:)
            self.connection.start(queue: .main)
        }
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
        self.didStopCallback(error)
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

    func rawReceive(length: Int) async throws -> Data? {
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
                    continuation.resume(returning: data)
                }
            }
        }
    }

}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
func setNetwork() -> Network {
#if os(iOS) || os(tvOS)
//  return Network("192.168.1.232", 19697)          // .. Ubuntu
    return Network("192.168.1.100", 19698)          // .. MaxBook
#else
    return Network()                                // "localhost", 19697
#endif
}

func setNetwork(_ ipAddr: String, _ ipPort: UInt16, start: Bool = false) -> Network {
    return Network(ipAddr, ipPort, start: true)
}
