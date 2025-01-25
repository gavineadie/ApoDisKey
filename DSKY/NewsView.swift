//
//  NewsView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jan24/25.
//

import SwiftUI

#if os(macOS)
struct NewsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("""
                Jan 27, 2025:
                   The initial release of ApoDisKey.
                """)
            .lineLimit(24)
            Button("Close") {
                NSApplication.shared.keyWindow?.close()
            }
        }
        .padding()
        .frame(minWidth: 240, minHeight: 160)
    }
}

#if swift(>=5.9)
#Preview("News") { NewsView() }
#endif

import AppKit

class NewsWindowController: NSWindowController {
    init() {
        let newsView = NewsView()
        let hostingController = NSHostingController(rootView: newsView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "News"
        window.contentView = hostingController.view
        window.center()

        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
