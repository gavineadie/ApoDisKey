//
//  DSKYApp.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/6/24.
//

import SwiftUI
import OSLog

let logger = Logger(subsystem: "com.ramsaycons.DSKY", category: "")

@main
struct DSKYApp: App {
    init() {

        let model = DisKeyModel.shared
        model.luminary099()

        let network = Network("127.0.0.1", 19697)
//      let network = Network("192.168.1.100", 19697)       // remote
        network.recv()

    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
