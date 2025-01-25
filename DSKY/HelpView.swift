//
//  HelpView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jan24/25.
//

import SwiftUI

#if os(macOS)
struct HelpView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("""
                **[ApoDisKey](https://github.com/gavineadie/ApoDisKey/blob/main/README.md)** \
                emulates the display and keyboard of the NASA Apollo Guidance Computer.

                In the late 1960's and early 1970's, the NASA Apollo program carried \
                twenty-seven men to the Moon, twelve of them descending to explore the lunar \
                surface, and back. \
                The Apollo astronaunts communicated with the AGC with a display/keyboard (DSKY) \
                peripheral. ApoDisKey's emulation of the DSKY is similarly separated from the \
                actual AGC and requires a running AGC emulator to communicate with (otherwise it \
                only presents a pretty face).

                Apollo documents and much of the AGC software is preserved at the \
                [Virtual AGC Project](https://www.ibiblio.org/apollo/). \
                Included there is cross-platform AGC simulator (yaAGC), \
                written in C, in the Virtual AGC software \
                [GitHub repository](https://github.com/virtualagc/virtualagc). \
                ApoDisKey communicates with yaAGC over TCP.

                Since ApoDisKey is very much an addendum to the Virtual AGC, the \
                [macOS download](https://www.ibiblio.org/apollo/download.html#Mac_OS_X) \
                is essential reading for the serious ApoDisKey user.
                """)
            .lineLimit(24)
            .multilineTextAlignment(.center)
            Button("Close") {
                NSApplication.shared.keyWindow?.close()
            }
        }
        .padding()
        .frame(minWidth: 480, minHeight: 360)
    }
}

#if swift(>=5.9)
#Preview("Help") { HelpView() }
#endif

import AppKit

class HelpWindowController: NSWindowController {
    init() {
        let helpView = HelpView()
        let hostingController = NSHostingController(rootView: helpView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Help"
        window.contentView = hostingController.view
        window.center()

        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
