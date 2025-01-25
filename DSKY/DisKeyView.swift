//
//  ContentView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
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
            Image("BackGround")         // 569 × 656 pixels
                .cornerRadius(18.0)

            VStack {
                HStack {
                    StatusView()
                    DisplayView()
                }

                KeyPadView()
            }
            .padding(.top, 5.0)
        }
        .onDrop(of: ["public.text"], isTargeted: nil) { providers in
            logger.log("drop providers: \(providers)")
            return true
        }
//        .ifMacOS_13()
// FIXME: Work needed ..
//        .dropDestination(for: URL.self) { urls, _ in
//            if let url = urls.first {
//                readCanned(path: url.path())
//                return true
//            } else {
//                return false
//            }
//        }

#if os(iOS)
        .scaleEffect(min(1.2, UIScreen.main.bounds.width/660.0))
#endif

    }
}

#if swift(>=5.9)
#Preview("DisKey") { DisKeyView() }
#endif

/*╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌*/
// extension View {
//    func ifMacOS_13() -> some View {
//        if #available(macOS 13.0, *) {
//            return modifier(DropDestination())
//        } else {
//            return self
//        }
//    }
// }
//
// struct DropDestination: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .dropDestination(for: URL.self) { urls, _ in
//                if let url = urls.first {
//                    readCanned(path: url.path())
//                    return true
//                } else {
//                    return false
//                }
//            }
//    }
// }
