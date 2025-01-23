//
//  DisKeyApp.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
//

import SwiftUI
import OSLog

let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "")
@MainActor var model = DisKeyModel.shared

@main
struct DisKeyApp: App {

#if os(macOS)
    class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

        func applicationWillTerminate(_ notification: Notification) {
            if model.windowX >= 0.0 && model.windowY >= 0.0 {
                UserDefaults.standard.removeObject(
                    forKey: "NSWindow Frame ApoDisKey.AppView-1-AppWindow-1")
            }
        }
    }

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif

    init() {

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ establish the global environment                                                                 ┆
  ┆ .. read init files                                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        extractOptions()                        // any command arguments ?

        if model.windowX >= 0.0 && model.windowY >= 0.0 {
            UserDefaults.standard.removeObject(
                forKey: "NSWindow Frame ApoDisKey.AppView-1-AppWindow-1")
        }

        startNetwork()
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ do other things as the ContentView runs ..                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

    var body: some Scene {
        WindowGroup {
            AppView()
        }
#if os(macOS)
        .defaultSize(CGSize(width: 569, height: 656))
        .defaultPosition(UnitPoint(x: model.windowX, y: model.windowY))
#endif
    }
}

struct AppView: View {
#if MONTEREY
#else
    let timer = Timer.publish(every: model.logTimer ? 1E1 : 1E8,
                              on: .main, in: .common).autoconnect()
#endif

    var body: some View {
        let scaleFactor = model.fullSize ? 1 : 0.5
        VStack {
            DisKeyView()
                .frame(width: 569 * scaleFactor,
                       height: 656 * scaleFactor)        // 569 × 656 pixels
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

    static var integer: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    var body: some View {
        HStack {

            Menu("Choose Mission") {
                Button("Apollo CM 8-17",
                       action: {
                    model.statusLights = DisKeyModel.commandModule
                    model.elPowerOn = true
                })
                Button("Apollo LM 11-14",
                       action: {
                    model.statusLights = DisKeyModel.lunarModule0
                    model.elPowerOn = true
                })
                Button("Apollo LM 15-17",
                       action: {
                    model.statusLights = DisKeyModel.lunarModule1
                    model.elPowerOn = true
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
                model.network = setNetwork(ipAddr, ipPort, start: true)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                Task {
                    var keepGoing = true
                    repeat {
                        do {
                            if let rxPacket = try await model.network.rawReceive(length: 4) {
                                if let (channel, action, _) =
                                    parseIoPacket(rxPacket) { channelAction(channel, action) }
                            }
                        } catch {
                            logger.error("\(error.localizedDescription)")
                            keepGoing = false
                        }
                    } while keepGoing
                }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ send a u-bit channel command to indicate channel 0o032 sends bit-14 to the AGC ..                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                Task {
                    let bit14: UInt16 = 0b0010_0000_0000_0000
                    do {
                        try await model.network.rawSend(data: formIoPacket(0o0232, bit14))
                        logger.log("«««    DSKY 032:    \(zeroPadWord(bit14)) BITS (15)")
                    } catch {
                        logger.error("\(error.localizedDescription)")
                    }
                }
            }
            )
            .disabled(ipAddr.isEmpty || ipPort == 0)
        }
        .padding(5)
        .background(.gray)
    }
}

#if swift(>=5.9)
#Preview("Monitor") { MonitorView() }
#endif
