//
//  KeyPadView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct KeyPadView: View {
    let model = DisKeyModel.shared

    var body: some View {
        HStack {
            VStack {
                KeyPadKey(keyCode: 17) // "VERB"
                KeyPadKey(keyCode: 31) // "NOUN"
            }

            VStack {
                HStack {
                    KeyPadKey(keyCode: 26) //  "+"
                    KeyPadKey(keyCode: 07) //  "7"
                    KeyPadKey(keyCode: 08) //  "8"
                    KeyPadKey(keyCode: 09) //  "9"
                    KeyPadKey(keyCode: 30) //  "CLR"
                }

                HStack {
                    KeyPadKey(keyCode: 27) //  "-"
                    KeyPadKey(keyCode: 04) //  "4"
                    KeyPadKey(keyCode: 05) //  "5"
                    KeyPadKey(keyCode: 06) //  "6"
                    KeyPadKey(keyCode: 99) //  "PRO"
                }

                HStack {
                    KeyPadKey(keyCode: 15) //  "0"
                    KeyPadKey(keyCode: 01) //  "1"
                    KeyPadKey(keyCode: 02) //  "2"
                    KeyPadKey(keyCode: 03) //  "3"
                    KeyPadKey(keyCode: 25) //  "KEY REL"
                }
            }

            VStack {
                KeyPadKey(keyCode: 28) // "ENTR"
                KeyPadKey(keyCode: 18) // "RSET"
            }
        }
    }
}

#Preview {
    KeyPadView()
}

struct KeyPadKey: View {
    let model = DisKeyModel.shared
    
    var keyCode: UInt16

    var body: some View {
        let fontSize: CGFloat = (1...16).contains(keyCode) ||
                               (26...27).contains(keyCode) ? 28 : 12

        Text(keyText(keyCode))
            .font(.custom("Gorton-Normal-120",
                          fixedSize: fontSize))
            .baselineOffset(-4.0)
            .tracking(2.0)
            .foregroundColor(keyTextColor)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .lineSpacing(4.0)
            .frame(width: keyPadSize,
                   height: keyPadSize)
            .background(keyPadColor)
            .padding(.all, keyPadding)
            .cornerRadius(keyCorner)
            .onTapGesture {
                record(keyCode)
                model.network.send(data: formIoPacket(0o015, keyCode))
            }
    }
}

#Preview {
    KeyPadKey(keyCode: 6)
}

#Preview {
    KeyPadKey(keyCode: 255)
}

func record(_ keyCode: UInt16) {
    logger.log("KeyPad: \(keyText(keyCode)) (\(keyCode))")
}

func keyText(_ code: UInt16) -> String {
    [17: "VERB",
     31: "NOUN",
     26:  "+",
     07:  "7",
     08:  "8",
     09:  "9",
     30:  "CLR",
     27:  "-",
     04:  "4",
     05:  "5",
     06:  "6",
     99:  "PRO",
     15:  "0",
     01:  "1",
     02:  "2",
     03:  "3",
     25:  "KEY REL",
     28: "ENTR",
     18: "RSET"][code] ?? "ERROR"
}
