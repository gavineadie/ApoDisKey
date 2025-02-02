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

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 19697, connect: Bool = false) {

        self.didStopCallback = { error in
            if let error = error {
                logger.log("←→ Connection stopped due to error: \(error.localizedDescription)")
            } else {
                logger.log("←→ Connection stopped successfully.")
            }
//          exit( error == nil ? EXIT_SUCCESS : EXIT_SUCCESS )  // Notify or update UI instead of calling exit().
        }

        let tcpOptions = NWProtocolTCP.Options()
        tcpOptions.connectionTimeout = 10

        self.connection = NWConnection(host: NWEndpoint.Host(host),
                                       port: NWEndpoint.Port(rawValue: port)!,
                                       using: NWParameters(tls: nil,
                                                           tcp: tcpOptions))
        if connect { start() }
    }

    func send(_ data: Data) async throws {
        try await connection.asyncSend(data: data)
    }

    func receive(length: Int) async throws -> Data? {
        try await connection.asyncReceive(length: length)
    }

    @Sendable private func stateDidChange(to state: NWConnection.State) {
        switch state {
            case .setup:
                logger.log("←→ .setup: The connection has been initialized but not started")
            case .waiting(let error):
                logger.log("←→ .waiting: \(error.localizedDescription)")
            case .preparing:
                logger.log("←→ .preparing: The connection in the process of being established")
            case .ready:
                logger.log("←→ .ready: The connection is established, and ready to send and receive data")
            case .failed(let error):
                logger.error("←→ .failed: \(error.localizedDescription)")
            case .cancelled:
                logger.error("←→ .cancelled: The connection has been canceled")
            @unknown default:
                fatalError("←→ network state: \(state) is not supported")  // \(String(describing: state))
        }
    }

    private func start() {
        self.connection.stateUpdateHandler = self.stateDidChange(to:)
        self.connection.start(queue: .main)
    }

    private func stop(error: Error?) {
        self.connection.stateUpdateHandler = nil
        self.connection.cancel()
        self.didStopCallback(error)
    }

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
        model.network = Network(model.ipAddr, model.ipPort, connect: true)
    }
#endif

#if os(iOS) || os(tvOS)
//  model.network = Network("192.168.1.232", 19697)                 // .. Ubuntu
    model.network = Network("192.168.1.100", 19697, connect: true)  // .. MaxBook
#endif

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    Task {
        var keepGoing = true
        repeat {
            do {
                if let rxPacket = try await model.network.receive(length: 4) {
                    if let (channel, action, _) =
                        parseIoPacket(rxPacket) { channelAction(channel, action) }
                }
            } catch {
                logger.error("←→ receive loop task: \(error.localizedDescription)")
                keepGoing = false
            }
        } while keepGoing
    }
}

extension NWConnection {

    func asyncSend(data: Data?) async throws {
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

    func asyncReceive(length: Int) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            receive(minimumIncompleteLength: length, maximumLength: length) { data, _, connectionEnded, error in
                if connectionEnded {
                    logger.log("←→ connection did end")
                }
                if let error {
                    precondition(data == nil)
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data ?? Data(repeating: 0, count: 4))
                }
            }
        }
    }

}
