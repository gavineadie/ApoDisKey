//
//  ContentView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/6/24.
//

import SwiftUI

let keyPadSize: CGFloat = 73
let keyPadding: CGFloat = -2
let panelSizeW: CGFloat = 222
let panelSizeH: CGFloat = 372


struct ContentView: View {

    var body: some View {
        ZStack {

            Rectangle()
                .fill(Color.yellow)
                .safeAreaInset(edge: .top) {
                    Text("↑  ↑  ↑  ↑  ↑")
                }
                .safeAreaInset(edge: .bottom) {
                    Text("↓  ↓  ↓  ↓  ↓")
                }
                .padding(8.0)

            Image("BackGround")
                .frame(width: /*@START_MENU_TOKEN@*/570.0/*@END_MENU_TOKEN@*/, 
                       height: /*@START_MENU_TOKEN@*/656.0/*@END_MENU_TOKEN@*/)

            VStack {
                HStack {
                    PanelsView()
                        .padding(.trailing, 18.0)
                    PanelsView()
                        .padding(.leading, 18.0)
                }
                KeyPadView()
                    .padding(.top, 13.0)
            }
            .padding(.top, 8.0)
        }
    }
}

#Preview {
    ContentView()
}

func button0() {
    logger.log("\(#function)")
}
