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
    @State private var helpWindowController: HelpWindowController?
    @State private var newsWindowController: NewsWindowController?
#endif

#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }

        func applicationDidFinishLaunching(_ notification: Notification) {
            if model.windowX > 0.0 && model.windowY > 0.0 {
                DispatchQueue.main.async {
                    if let window = NSApplication.shared.windows.first {
                        window.setFrame(NSRect(origin: NSPoint(x: model.windowX - 0.0,
                                                               y: model.windowY + 0.0),
                                               size: NSSize(width: model.windowW,
                                                            height: model.windowH)),
                                        display: true)
                        window.contentMaxSize = NSSize(width: model.windowW,
                                                       height: model.windowH)
                    }
                }
            }
        }

//      .defaultSize(CGSize(width: model.windowW, height: model.windowH))
//      .defaultPosition(UnitPoint(x: model.windowX, y: model.windowY))

        func applicationWillTerminate(_ notification: Notification) {
            if model.windowX >= 0.0 && model.windowY >= 0.0 {
                UserDefaults.standard.removeObject(
                    forKey: "NSWindow Frame ApoDisKey.AppView-1-AppWindow-1")
            }
        }
    }
#endif

    init() {

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ establish the global environment                                                                 ┆
  ┆ .. read init files                                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        model.windowW = CGFloat(569)
        model.windowH = CGFloat(656)

#if os(macOS)
        extractOptions()                        // get any command arguments ..
#endif

        if model.windowX >= 0.0 && model.windowY >= 0.0 {
            UserDefaults.standard.removeObject(
                forKey: "NSWindow Frame ApoDisKey.AppView-1-AppWindow-1")
        }

        startNetwork()
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ do other things as the ContentView runs ..                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

//    var body: some Scene {
//        if #available(macOS 13.0, *) {
//            WindowGroup {
//                AppView()
//            }
//            .defaultSize(CGSize(width: 569, height: 656))
//            .defaultPosition(UnitPoint(x: model.windowX, y: model.windowY))
//        } else {
//            WindowGroup {
//                AppView()
//            }
//            .windowLevel(.normal)
//        }
//    }

    var body: some Scene {
        WindowGroup {
            AppView()
        }
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
// FIXME: Work needed ..
// #if os(macOS)
//        if #available(macOS 13.0, *) {
//            .defaultSize(CGSize(width: 569, height: 656))
//            .defaultPosition(UnitPoint(x: model.windowX, y: model.windowY))
//        }
// #endif

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ This puts "Help" in the "Window" menu ..                                                         ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
//#if os(macOS)
//        if #available(macOS 13.0, *) {
//            Window("Help", id: "help") { HelpView() }
//        }
//#endif
    }

#if os(macOS)
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
                    var keepGoing = true
                    repeat {
                        do {
                            if let rxPacket = try await model.network.receive(length: 4) {
                                if let (channel, action, _) =
                                    parseIoPacket(rxPacket) { channelAction(channel, action) }
                            }
                        } catch {
                            logger.error("←→ rx loop (button): \(error.localizedDescription)")
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
                        try await model.network.send(formIoPacket(0o0232, bit14))
                        logger.log("«««    DSKY 032:    \(zeroPadWord(bit14)) BITS (15)")
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
