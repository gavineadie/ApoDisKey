//
//  MonitorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 11/27/24.
//

import SwiftUI

struct MonitorView: View {

    @State private var ipAddr: String = ""
    @State private var ipPort: UInt = 0

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
                    model.elPanelOff = false
                })
                Button("Apollo LM 11-14",
                       action: {
                    model.statusLights = DisKeyModel.LM0
                    model.elPanelOff = false
                })
                Button("Apollo LM 15-17",
                       action: {
                    model.statusLights = DisKeyModel.LM1
                    model.elPanelOff = false
                })
            }

            TextField("AGC Address",
                      text: $ipAddr,
                      onEditingChanged: { tf in
                                print("onEditingChanged \(tf)")
                            },
                      onCommit: {
                                print("onCommit")
                            })
//            .foregroundColor(.blue)
//            .background(.yellow)
            .font(.custom("Menlo", size: 12))

            TextField("AGC PortNum",
                      value: $ipPort,
                      formatter: MonitorView.number)
            .font(.custom("Menlo", size: 12))

            Button("Connect",
                   systemImage: "phone.connection",
                   action: { print("connect") } )
            .disabled(ipAddr.isEmpty || ipPort == 0)
        }
        .padding(5)
        .background(.gray)
    }
}

#Preview {
    MonitorView()
}
