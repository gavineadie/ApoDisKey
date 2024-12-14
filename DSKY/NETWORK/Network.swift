//
//  Network.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/15/24.
//

import Foundation
@preconcurrency import Network

struct Network : Sendable{

    let connection: NWConnection
    let didStopCallback: @Sendable (Error?) -> Void

    init(_ host: String = "127.0.0.1", _ port: UInt16 = 12345, start: Bool = false) {

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
  │ defaults set by:                                                                                 │
  │         defaults write com.ramsaycons.ApoDisKey ipAddr "127.0.0.1"                               │
  │         defaults write com.ramsaycons.ApoDisKey ipPort 19697                                     │
  │ defaults removed by:                                                                             │
  │         defaults delete com.ramsaycons.ApoDisKey ipAddr                                          │
  │         defaults delete com.ramsaycons.ApoDisKey ipPort                                          │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
func setNetwork() -> Network {
/*box..
 if we find UserDefault values, use them ..
 */
    if let ipAddr = UserDefaults.standard.string(forKey: "ipAddr") {
        var ipPort = UInt16(UserDefaults.standard.integer(forKey: "ipPort"))
        if ipPort == 0 {
            ipPort = 19697
        }
    logger.log("→→→ appDefaults: ipAddr=\(ipAddr, privacy: .public), ipPort=\(ipPort, privacy: .public)")
        return Network(ipAddr, ipPort)
    } else {
#if os(iOS) || os(tvOS)
//  return Network("192.168.1.232", 19697)          // .. Ubuntu
    return Network("192.168.1.100", 19698)          // .. MaxBook
#else
    return Network("localhost", 19697)
#endif
    }
}

func setNetwork(_ ipAddr: String, _ ipPort: UInt16, start: Bool = false) -> Network {
    logger.log("→→→ monitor set: ipAddr=\(ipAddr, privacy: .public), ipPort=\(ipPort, privacy: .public)")
    return Network(ipAddr, ipPort, start: true)
}
