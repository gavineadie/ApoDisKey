//
//  ContentView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/6/24.
//

import SwiftUI

let keyPadSize: CGFloat = 73
let keyPadding: CGFloat = -2
let keyCorner: CGFloat = 3
let keyText: Color = .white

let panelExSizeW: CGFloat = 222
let panelExSizeH: CGFloat = 372
let panelExCorner: CGFloat = 10

let panelInset: CGFloat = 26
let panelInCorner: CGFloat = 8
let panelDigitSize: CGFloat = 37

let statusWidth: CGFloat = 90
let statusHeight: CGFloat = 44
let statusCorner: CGFloat = 6

#if os(iOS)
let panelExColor = Color(uiColor: .systemGray2)     // 2...6
let panelInColor = Color(uiColor: .systemGray4)     // 2...6
let statusBorder = Color(uiColor: .darkGray)
let statusText: Color = .black
#else
let panelExColor = Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
let panelInColor = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
let statusBorder: Color = .gray
let statusText: Color = .black
#endif

let zerlinaFixedSize: CGFloat = 46.0
let zerlinaTracking: CGFloat = 4.0


struct ContentView: View {

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.9,
                                          green: 0.9,
                                          blue: 0.8,
                                          alpha: 1)))
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
                    .padding(.top, 13.0)
            }
            .padding(.top, 8.0)
        }
    }
}

#Preview {
    ContentView()
}
