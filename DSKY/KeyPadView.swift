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
        let fontSize: CGFloat = (symbol.count == 1) ? 28 : 12

        Text(symbol)
            .font(.custom("Gorton-Normal-120",
                          fixedSize: fontSize))
            .baselineOffset(-4.0)
            .tracking(2.0)
            .foregroundColor(Color(keyText))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .lineSpacing(4.0)
            .frame(width: keyPadSize,
                   height: keyPadSize)
            .background(Color(.darkGray))
            .padding(.all, keyPadding)
            .cornerRadius(keyCorner)
            .onTapGesture {
                log(symbol)
            }

    }
}

#Preview {
    KeyPadKey(symbol: "6")
}

#Preview {
    KeyPadKey(symbol: "ZASO")
}

func log(_ symbol: String) {
    logger.log("KeyPad: \(symbol)")
}
