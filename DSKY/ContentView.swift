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

let panelExSizeW: CGFloat = 222
let panelExSizeH: CGFloat = 374
let panelExCorner: CGFloat = 10

let panelInset: CGFloat = 26
let panelInCorner: CGFloat = 8
let panelDigitSize: CGFloat = 37

let statusWidth: CGFloat = 90
let statusHeight: CGFloat = 44
let statusCorner: CGFloat = 6

let backgroundColor = Color(red: 0.9, green: 0.9, blue: 0.8)

let panelExColor = Color(white: 0.25)
let panelInColor = Color(white: 0.35)

let statusBorder = Color(white: 0.5)
let statusText = Color(white: 0.0)

let displayElectro = Color(red: 0.1, green: 0.8, blue: 0.1)
let displayWhiteDot = Color(white: 0.9)

let keyTextColor = Color(white: 0.9)
let keyPadColor = Color(white: 0.25)

let zerlinaFixedSize: CGFloat = 46.0
let zerlinaTracking: CGFloat = 4.0

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
