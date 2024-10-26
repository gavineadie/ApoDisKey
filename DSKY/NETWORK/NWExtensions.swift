// https://forums.swift.org/t/socket-api/19971/31

import Foundation
import Network

extension NWConnection {
    
    private func rawSend(data: Data?) async throws {
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
    
    private func rawReceive(length: Int) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            receive(minimumIncompleteLength: length,
                    maximumLength: length) { data, context, isComplete, error in
                precondition(isComplete)
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
