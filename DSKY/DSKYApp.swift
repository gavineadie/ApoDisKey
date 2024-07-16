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
        dskySetup()
        let client = Network()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func dskySetup() {
        logger.log("\(#function) ..")
//        allOn()
    }
}
