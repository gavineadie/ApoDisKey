import Foundation
import OSLog
import ApolloNetwork

@MainActor
final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()

    private let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "NetworkManager")

    @Published private(set) var isReady: Bool = false
    @Published private(set) var isReceiving: Bool = false
    @Published private(set) var host: String = ""
    @Published private(set) var port: UInt16 = 0

    private var network: Network?
    private var receiveTask: Task<Void, Never>?

    func connect(host: String, port: UInt16) {
        // Cancel any existing session
        disconnect()

        self.host = host
        self.port = port
        let connection = Network(host, port)
        self.network = connection
        connection.start()

        // Optimistically set readiness; will adjust via polling state
        updateReadyState()
        startReceiveLoop()
    }

    func useExistingAndStart(host: String, port: UInt16) {
        // Helper used by startNetwork() when cmd args or platform defaults exist
        connect(host: host, port: port)
    }

    func disconnect() {
        receiveTask?.cancel()
        receiveTask = nil
        isReceiving = false
        isReady = false
        network = nil
    }

    func send(_ data: Data) async throws {
        guard let network else { throw NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No connection"]) }
        try await network.send(data)
    }

    private func startReceiveLoop() {
        guard let network else { return }
        if receiveTask != nil { return } // already running

        isReceiving = true
        receiveTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                // Update readiness each iteration
                self.updateReadyState()
                do {
                    let data = try await network.receive(length: 4)
                    let (channel, action) = try parseIoPacket(data)
                    channelAction(channel, action)
                } catch PacketError.ignore_FF_FF_FF_FF {
                    continue
                } catch {
                    self.logger.error("←→ rx loop exit: \(error.localizedDescription)")
                    break
                }
            }
            await MainActor.run {
                self.isReceiving = false
            }
        }
    }

    private func updateReadyState() {
        if let network {
            isReady = (network.state == .ready)
        } else {
            isReady = false
        }
    }
}
