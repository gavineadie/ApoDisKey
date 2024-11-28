//
//  MonitorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 11/27/24.
//

import SwiftUI

struct MonitorView: View {
    var body: some View {
        VStack {

            Text("IP address: ..")
            Text("IP port: ..")

            Menu("Choose Mission") {
                Button("Apollo CM 8-17",
                       action: {
                    model.statusLights = DisKeyModel.CM
                    model.elPanelOff = false
                })
                Button("Apollo LM 11-14",
                       action: { model.statusLights = DisKeyModel.LM0 })
                Button("Apollo LM 15-17",
                       action: { model.statusLights = DisKeyModel.LM1 })
                Button("*** Power Off ***",
                       action: { model.statusLights = DisKeyModel.OFF
                    model.elPanelOff = true
})
            }

            .padding(/*@START_MENU_TOKEN@*/.all, 20.0/*@END_MENU_TOKEN@*/)
        }

    }
}

#Preview {
    MonitorView()
}
