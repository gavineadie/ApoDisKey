//
//  DisKeyApp.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
//

import SwiftUI
import ApolloNetwork
import OSLog

let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "main")

@MainActor var model = DisKeyModel.shared

@main
struct DisKeyApp: App {

#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
    }
#endif

    init() {

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ establish the global environment                                                                 ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        model.windowW = CGFloat(569)
        model.windowH = CGFloat(656)

#if os(macOS)
        extractOptions()                        // get any command arguments ..
#endif

        startNetwork()
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ do other things as the ContentView runs ..                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .defaultSize(CGSize(width: model.windowW, height: model.windowH))
#if os(macOS)
        .defaultPosition(UnitPoint(x: model.windowX, y: model.windowY))
#endif
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Menu management ..                                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        .commands {
            CommandGroup(replacing: .pasteboard) { }        // "Cut", "Copy", "Paste", ..
            CommandGroup(replacing: .newItem) { }           // "File" removed ("New", "Open", ..)
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .systemServices) { }
            CommandGroup(replacing: .windowSize) { }
            CommandGroup(replacing: .windowArrangement) { }
#if os(macOS)
            CommandGroup(replacing: .help) {
                Button("ApoDisKey Help") { openHelpWindow() }
                Button("ApoDisKey News") { openNewsWindow() }
            }
#endif
        }
    }

#if os(macOS)
    @State private var helpWindowController: HelpWindowController?
    @State private var newsWindowController: NewsWindowController?

    private func openHelpWindow() {
        if helpWindowController == nil {
            helpWindowController = HelpWindowController()
        }
        helpWindowController?.showWindow(nil)
        helpWindowController?.window?.makeKeyAndOrderFront(nil)
    }

    private func openNewsWindow() {
        if newsWindowController == nil {
            newsWindowController = NewsWindowController()
        }
        newsWindowController?.showWindow(nil)
        newsWindowController?.window?.makeKeyAndOrderFront(nil)
    }
#endif

}

struct AppView: View {
    var body: some View {
        let scaleFactor = model.fullSize ? 1 : 0.5
        VStack {
            DisKeyView()
                .frame(width: model.windowW, height: model.windowH)        // 569 × 656 pixels
                .scaleEffect(scaleFactor)
#if os(macOS)
            if model.fullSize && !model.haveCmdArgs {
                Divider()
                MonitorView()
            }
#endif
        }
    }
}

#if swift(>=5.9)
#Preview("AppView") { AppView() }
#endif

struct MonitorView: View {

    @State private var ipAddr: String = ""
    @State private var ipPort: UInt16 = 0
    @State private var menuString = "Select Mission"

    static var integer: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    var body: some View {
        HStack {

            Menu(menuString) {
                Button("Apollo CM 8-17",
                       action: {
                    model.statusLights = DisKeyModel.commandModule
                    model.elPowerOn = true
                    menuString = "Apollo CM 8-17"
                })
                Button("Apollo LM 11-14",
                       action: {
                    model.statusLights = DisKeyModel.lunarModule0
                    model.elPowerOn = true
                    menuString = "Apollo LM 11-14"
                })
                Button("Apollo LM 15-17",
                       action: {
                    model.statusLights = DisKeyModel.lunarModule1
                    model.elPowerOn = true
                    menuString = "Apollo LM 15-17"
                })
            }

            TextField("AGC Address", text: $ipAddr)
                .font(.custom("Menlo", size: 12))

            TextField("AGC PortNum", value: $ipPort, formatter: MonitorView.integer)
                .font(.custom("Menlo", size: 12))
            
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. make network connection                                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            Button("Connect",
                   systemImage: "phone.connection",
                   action: {
                model.ipAddr = ipAddr
                model.ipPort = ipPort
                logger.log("""
                    →→→ monitor set: \
                    ipAddr=\(ipAddr, privacy: .public), \
                    ipPort=\(ipPort, privacy: .public)
                    """)
                model.network = Network(ipAddr, ipPort, connect: true)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                Task {
                    while true {
                        do {
                            let (channel, action, _) = try parseIoPacket(try await model.network.receive(length: 4))
                                channelAction(channel, action)

                        } catch {
                            logger.error("←→ rx loop exit: \(error.localizedDescription)")
                            break
                        }
                    }
                }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ send a u-bit channel command to indicate channel 0o032 sends bit-14 to the AGC ..                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                Task {
                    let value: UInt16 = 0b0010_0000_0000_0000
                    do {
                        try await model.network.send(formIoPacket(0o0232, value))
                        logger.log("«««    DSKY 032:    \(zeroPadWord(value)) BITS (15)")
                    } catch {
                        logger.error("\(error.localizedDescription)")
                    }
                }
            } )
            .disabled(ipAddr.isEmpty || ipPort == 0 || menuString == "Select Mission")
        }
        .padding(5)
        .background(.gray)
    }
}

#if swift(>=5.9)
#Preview("Monitor") { MonitorView() }
#endif

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
    model.statusLights = DisKeyModel.lunarModule0
    model.elPowerOn = true
//  model.network = Network("192.168.1.232", 19697)                 // .. Ubuntu
    model.network = Network("192.168.1.100", 19697, connect: true)  // .. MaxBook
//  model.network = Network("192.168.1.192", 19697, connect: true)  // .. iPhone
//  model.network = Network("192.168.1.228", 19697, connect: true)  // .. iPadM4
//  model.network = Network("127.0.0.1",     19697, connect: true)  // .. localhost
#endif

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    Task {
        while true {
            do {
                let (channel, action, _) = try parseIoPacket(try await model.network.receive(length: 4))
                channelAction(channel, action)
            } catch PacketError.ignore_FF_FF_FF_FF {
            } catch {
                logger.error("←→ rx loop exit: \(error.localizedDescription)")
                break
            }
        }
    }
}
