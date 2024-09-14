//
//  ContentView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/6/24.
//

import SwiftUI

/*
        ┌───────────────────────┐    ┌───────────────────────┐
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
        │ ┆ UPLINK ┆ ┆  TEMP  ┆ │    │ ┆ "COMP" ┆ ┆ "PROG" ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆        ┆ ┆        ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆        ┆ ┆        ┆ │
        │ ┆ NO ATT ┆ ┆ GIMBAL ┆ │    │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆ "VERB" ┆ ┆ "NOUN" ┆ │
        │ ┆  STBY  ┆ ┆  PROG  ┆ │    │ ┆        ┆ ┆        ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆        ┆ ┆        ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
        │ ┆KEY REL ┆ ┆RESTART ┆ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆ REGISTER1         ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆                   ┆ │
        │ ┆OPR ERR ┆ ┆TRACKER ┆ │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆ REGISTER2         ┆ │
        │ ┆        ┆ ┆  ALT   ┆ │    │ ┆                   ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ┆        ┆ ┆  VEL   ┆ │    │ ┆ REGISTER3         ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆                   ┆ │
        │                       │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        └───────────────────────┘    └───────────────────────┘
        ┌────────────────────────────────────────────────────┐
        │         ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮         │
        │         ┆+   ┆ ┆7   ┆ ┆8   ┆ ┆9   ┆ ┆CLR ┆         │
        │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
        │  ┆VERB┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆ENTR┆  │
        │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
        │  ╰╌╌╌╌╯ ┆-   ┆ ┆4   ┆ ┆5   ┆ ┆6   ┆ ┆PRO ┆ ╰╌╌╌╌╯  │
        │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
        │  ┆NOUN┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆RSET┆  │
        │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
        │  ╰╌╌╌╌╯ ┆0   ┆ ┆1   ┆ ┆2   ┆ ┆3   ┆ ┆KEY ┆ ╰╌╌╌╌╯  │
        │         ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆REL ┆         │
        │         ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯         │
        └────────────────────────────────────────────────────┘
*/

struct DisKeyView: View {
    let model = DisKeyModel.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .padding(-80.0)

            Image("BackGround")
                .cornerRadius(18.0)

            VStack {
                HStack {
                    StatusView()
                        .padding(.trailing, 18.0)
                    DisplayView()
                        .padding(.leading, 18.0)
                }

                KeyPadView()
                    .padding(.top, 16.0)
            }
            .padding(.top, 5.0)
        }
#if os(iOS) || os(tvOS)
        .scaleEffect(0.65)
#endif

        HStack {
            Text("T1").background(Rectangle().stroke()).onTapGesture(perform: statusAllOff)
            Text("T2").background(Rectangle().stroke()).onTapGesture(perform: statusAllYellow)
            Text("T3").background(Rectangle().stroke()).onTapGesture(perform: model.luminary099)
            Text("T4").background(Rectangle().stroke()).onTapGesture(perform: model.comanche055)

            Text(DisKeyModel.shared.statusFooter)
                .font(.footnote)
                .foregroundColor(Color.red)
        }
        .dropDestination(for: URL.self) { urls, _ in
            if let url = urls.first {
                readCanned(path: url.path())
                return true
            } else {
                return false
            }
        }
    }
}

#Preview {
    DisKeyView()
}


/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ silly tests ..                                                                                   ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func statusAllOff() {
    let model = DisKeyModel.shared
    logger.log("... \(#function)")
    for (key, _) in model.statusLights { model.statusLights[key] = ("« OFF »", .off) }
}

func statusAllYellow() {
    let model = DisKeyModel.shared
    logger.log("... \(#function)")
    for (key, _) in model.statusLights { model.statusLights[key] = ("YELLOW", .yellow) }
}
