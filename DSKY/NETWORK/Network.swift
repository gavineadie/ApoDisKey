//
//  Network.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul15/24 (copyright 2024-25)
//

import Foundation
@preconcurrency import Network

struct Network: Sendable {

    let connection: NWConnection
    let didStopCallback: @Sendable (Error?) -> Void

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 19697, start: Bool = false) {

        self.didStopCallback = { error in
            if let error = error {
                logger.log("🛜 Connection stopped due to error: \(error.localizedDescription)")
            } else {
                logger.log("🛜 Connection stopped successfully.")
            }
            exit( error == nil ? EXIT_SUCCESS : EXIT_SUCCESS )  // Notify or update UI instead of calling exit().
        }

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 10

        self.connection = NWConnection(host: NWEndpoint.Host(host),
                                       port: NWEndpoint.Port(rawValue: port)!,
                                       using: NWParameters(tls: nil,
                                                           tcp: tcpOptions))
        if start {
            self.connection.stateUpdateHandler = self.stateDidChange(to:)
            self.connection.start(queue: .main)
        }
    }

    func rawSend(data: Data?) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.connection.send(content: data, completion: .contentProcessed { error in
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
            self.connection.receive(minimumIncompleteLength: length,
                    maximumLength: length) { data, _, connectionEnded, error in
                if let error {
                    precondition(data == nil)
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data)
                }
                if connectionEnded {
                    logger.log("🛜 connection did end")
                    stop(error: nil)
                }
            }
        }
    }

    @Sendable private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .setup:
            logger.log("🛜 .setup: The connection has been initialized but not started")
        case .waiting(let error):
            logger.log("🛜 .waiting: \(error.localizedDescription)")
        case .preparing:
            logger.log("🛜 .preparing: The connection in the process of being established")
        case .ready:
            logger.log("🛜 .ready: The connection is established, and ready to send and receive data")
        case .failed(let error):
            logger.log("🛜 .failed: \(error.localizedDescription)")
            self.stop(error: error)
        case .cancelled:
            logger.log("🛜 .cancelled: The connection has been canceled")
        @unknown default:
            fatalError("The state: \(state) is not supported")  // \(String(describing: state))
        }
    }

    private func stop(error: Error?) {
        self.connection.stateUpdateHandler = nil
        self.connection.cancel()
        self.didStopCallback(error)
    }

}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
func setNetwork(start: Bool = false) -> Network {
#if os(iOS) || os(tvOS)
//  return Network("192.168.1.232", 19697)              // .. Ubuntu
    return Network("192.168.1.100", 19697, start: true) // .. MaxBook
#else
    return Network()                                    // "localhost", 19697
#endif
}

func setNetwork(_ ipAddr: String, _ ipPort: UInt16, start: Bool = false) -> Network {
    return Network(ipAddr, ipPort, start: true)
}

@MainActor
func startNetwork() {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ if command arguments for network are good, use them ..                                           ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
#if os(macOS)
    if model.haveCmdArgs {
        logger.log("""
            →→→ cmdArgs set: \
            ipAddr=\(model.ipAddr, privacy: .public), \
            ipPort=\(model.ipPort, privacy: .public)
            """)
        model.network = setNetwork(model.ipAddr, model.ipPort, start: true)
    }
#endif

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    Task {
        var keepGoing = true
        repeat {
            do {
                if let rxPacket = try await model.network.rawReceive(length: 4) {
                    if let (channel, action, _) =
                        parseIoPacket(rxPacket) { channelAction(channel, action) }
                }
            } catch {
                logger.error("\(error.localizedDescription)")
                keepGoing = false
            }
        } while keepGoing
    }
}
