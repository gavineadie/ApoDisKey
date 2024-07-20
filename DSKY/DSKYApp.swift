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

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
    establish the global environment
    .. read init files
    .. make network connection
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        let model = DisKeyModel.shared
        model.luminary099()

//      let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//          let timeString = String(String(Date.timeIntervalSinceReferenceDate)
//              .dropFirst(4)
//              .prefix(5))
//          model.register3 = ("+\(timeString)", true)
//      }

        model.network.recv()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
