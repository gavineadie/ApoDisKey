//
//  NetworkManager.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/11/25.
//

import Foundation
import ApolloNetwork

actor NetworkManager {
    private var network: Network?

    func connect(ipAddr: String, port: UInt16) async throws {
        network = Network(ipAddr, port, connect: true)
    }

    func receive(length: Int) async throws -> Data {
        guard let network else { throw NetworkError.notConnected }
        return try await network.receive(length: length)
    }

    func send(_ data: Data) async throws {
        guard let network else { throw NetworkError.notConnected }
        try await network.send(data)
    }
    
    func state() async -> NetworkState {
        guard let network else { return NetworkState.none }
        return NetworkState.ready
    }
}

enum NetworkError: Error {
    case notConnected
}

enum NetworkState {
    case none
    case setup
    case preparing
    case ready
    case waiting
    case failed
    case cancelled
}
