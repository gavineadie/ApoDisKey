//
//  ContentView.swift
//  ApoDisKey
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
    var body: some View {

        ZStack {
//            Rectangle()
//                .fill(backgroundColor)
//                .padding(-80.0)

            Image("BackGround")         // width=656px
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

#if os(iOS)
        .scaleEffect(min(1.2, UIScreen.main.bounds.width/660.0))
#endif

        if #available(macOS 13.0, *) {
            Text("drop")
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
}

struct DisKeyView_Previews: PreviewProvider {
    static var previews: some View {
        DisKeyView()
    }
}
