//
//  DisKeyApp.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul06/24.
//

import SwiftUI
import OSLog

let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "")
@MainActor var model = DisKeyModel.shared

@main
struct DisKeyApp: App {

    init() {

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ establish the global environment                                                                 ┆
  ┆ .. read init files                                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
//        let homeURL = locateAppSupport()              // "~/ApoDisKey"
//        if homeURL.isFileURL { logger.log("••• \(homeURL) isn't a file.") }

        extractOptions()
    }
    
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ do other things as the ContentView runs ..                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}

struct AppView: View {
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            DisKeyView()
                .padding(.bottom, 10.0)
            Divider()
                .onReceive(timer) { date in logger.log("TEN SECONDS: \(date)") }
            MonitorView()
        }
    }
}

#Preview("AppView") {
    AppView()
}

struct MonitorView: View {

    @State private var ipAddr: String = ""
    @State private var ipPort: UInt16 = 0

    static var number: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        HStack {

            Menu("Choose Mission") {
                Button("Apollo CM 8-17",
                       action: {
                    model.statusLights = DisKeyModel.CM
                    model.elPowerOn = true
                })
                Button("Apollo LM 11-14",
                       action: {
                    model.statusLights = DisKeyModel.LM0
                    model.elPowerOn = true
                })
                Button("Apollo LM 15-17",
                       action: {
                    model.statusLights = DisKeyModel.LM1
                    model.elPowerOn = true
                })
            }

            TextField("AGC Address", text: $ipAddr)
            .font(.custom("Menlo", size: 12))

            TextField("AGC PortNum", value: $ipPort,
                      formatter: MonitorView.number)
            .font(.custom("Menlo", size: 12))

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. make network connection                                                                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            Button("Connect",
                   systemImage: "phone.connection",
                   action: {
                print("connect")
                model.ipAddr = ipAddr
                model.ipPort = ipPort
                model.network = setNetwork(ipAddr, ipPort, start: true)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                Task {
                    var keepGoing = true
                    repeat {
                        do {
                            if let rxPacket = try await model.network.connection
                                .rawReceive(length: 4) {
                                if let (channel, action, _) =
                                    parseIoPacket(rxPacket) { channelAction(channel, action) }
                            }
                        } catch {
                            print(error.localizedDescription)
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
                        try await model.network.connection
                            .rawSend(data: formIoPacket(0o0232, bit14))
                        logger.log("«««    DSKY 032:    \(ZeroPadWord(bit14)) BITS (15)")
                    } catch {
                        print(error.localizedDescription)
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

#Preview("Monitor") {
    MonitorView()
}
