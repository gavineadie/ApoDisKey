//
//  ContentView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/6/24.
//

import SwiftUI

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮

        ┌───────────────────────┐    ┌───────────────────────┐
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
        │ ┆        ┆ ┆        ┆ │    │ ┆ "COMP" ┆ ┆ "PROG" ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆        ┆ ┆        ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆        ┆ ┆        ┆ │
        │ ┆        ┆ ┆        ┆ │    │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆ "VERB" ┆ ┆ "NOUN" ┆ │
        │ ┆        ┆ ┆        ┆ │    │ ┆        ┆ ┆        ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆        ┆ ┆        ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
        │ ┆        ┆ ┆        ┆ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆ REGISTER1         ┆ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆                   ┆ │
        │ ┆        ┆ ┆        ┆ │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ┆ REGISTER2         ┆ │
        │ ┆        ┆ ┆        ┆ │    │ ┆                   ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │    │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
        │ ┆        ┆ ┆        ┆ │    │ ┆ REGISTER3         ┆ │
        │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │    │ ┆                   ┆ │
        │                       │    │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
        └───────────────────────┘    └───────────────────────┘

        ┌────────────────────────────────────────────────────┐
        │         ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮         │
        │         ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆         │
        │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
        │  ┆    ┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆    ┆  │
        │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
        │  ╰╌╌╌╌╯ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╰╌╌╌╌╯  │
        │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
        │  ┆    ┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆    ┆  │
        │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
        │  ╰╌╌╌╌╯ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╰╌╌╌╌╯  │
        │         ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆         │
        │         ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯         │
        └────────────────────────────────────────────────────┘

  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

struct ContentView: View {
    let model = DisKeyModel.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .padding(8.0)

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

        HStack {
            Text("T1").background(Rectangle().stroke()).onTapGesture(perform: statusAllOff)
            Text("T2").background(Rectangle().stroke()).onTapGesture(perform: statusAllYellow)
            Text("T3").background(Rectangle().stroke()).onTapGesture(perform: model.luminary099)
            Text("T4").background(Rectangle().stroke()).onTapGesture(perform: model.comanche055)

            Text(DisKeyModel.shared.statusFooter)
                .font(.footnote)
                .foregroundColor(Color.red)
        }
    }
}

#Preview {
    ContentView()
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
