//
//  KeyPadView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct KeyPadView: View {
    var body: some View {
        HStack {
            VStack {
                KeyPadKey(symbol: "VERB")
                KeyPadKey(symbol: "NOUN")
            }

            VStack {
                HStack {
                    KeyPadKey(symbol: "+")
                    KeyPadKey(symbol: "7")
                    KeyPadKey(symbol: "8")
                    KeyPadKey(symbol: "9")
                    KeyPadKey(symbol: "CLR")
                }

                HStack {
                    KeyPadKey(symbol: "-")
                    KeyPadKey(symbol: "4")
                    KeyPadKey(symbol: "5")
                    KeyPadKey(symbol: "6")
                    KeyPadKey(symbol: "PRO")
                }

                HStack {
                    KeyPadKey(symbol: "0")
                    KeyPadKey(symbol: "1")
                    KeyPadKey(symbol: "2")
                    KeyPadKey(symbol: "3")
                    KeyPadKey(symbol: "KEY\nREL")
                }
            }

            VStack {
                KeyPadKey(symbol: "ENTR")
                KeyPadKey(symbol: "RSET")
            }
        }
    }
}

#Preview {
    KeyPadView()
}


struct KeyPadKey: View {
    var symbol: String

    var body: some View {
        Button(symbol) { log(symbol) }
            .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color(keyText))
            .frame(width: keyPadSize,
                   height: keyPadSize)
            .background(Color(.darkGray))
            .padding(.all, keyPadding)
            .cornerRadius(keyCorner)
    }
}

#Preview {
    KeyPadKey(symbol: "Z")
}

func log(_ symbol: String) {
    logger.log("KeyPad: \(symbol)")
}
