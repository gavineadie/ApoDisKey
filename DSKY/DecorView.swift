//
//  DecorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/9/24.
//

import SwiftUI

let keyPadSize: CGFloat = 73.0
let keyPadding: CGFloat = -2.0
let keyCorner: CGFloat = 3.0

let panelExSizeW: CGFloat = 222.0
let panelExSizeH: CGFloat = 374.0

let panelInset: CGFloat = 26.0
let panelDigitSize: CGFloat = 37.0

let statusWidth: CGFloat = 90.0
let statusHeight: CGFloat = 44.0
let statusCorner: CGFloat = 6.0

let backgroundColor = Color(red: 0.9, green: 0.9, blue: 0.8)

let statusBorder = Color(white: 0.5)
let statusText = Color(white: 0.0)

let displayElectro = Color(red: 0.1, green: 0.8, blue: 0.1)

let keyTextColor = Color(white: 0.9)
let keyPadColor = Color(white: 0.25)

let zerlinaFixedSize: CGFloat = 46.0
let zerlinaTracking: CGFloat = 4.0

/*
            ╭───────────────────────╮
            │ ╭───────────────────╮ │
            │ │                   │<--- exterior color (edge)
            │ │         <-------------- interior color
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ │                   │ │
            │ ╰───────────────────╯ │
            ╰───────────────────────╯
*/

struct PanelsView: View {
    var interiorFill: Color = Color(white: 0.35)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: 0.25))
                .frame(width: panelExSizeW,
                       height: panelExSizeH)

            RoundedRectangle(cornerRadius: 6)
                .fill(interiorFill)
                .frame(width: panelExSizeW-panelInset,
                       height: panelExSizeH-panelInset)
        }
        .shadow(color: Color.black.opacity(0.6),
                radius: 4.0,
                x: 4.0, y: 4.0)
    }
}

#Preview("Panels") { PanelsView(interiorFill: .brown) }

struct DisplaySeparator: View {
    var body: some View {
        HStack {
            LittleWhiteCircle()

            RoundedRectangle(cornerRadius: 1)
                .padding(.horizontal, -4.0)
                .frame(height: 4.0)
                .foregroundColor(model.elPowerOn ? displayElectro : .clear)

            LittleWhiteCircle()
        }
        .frame(width: 192,
               height: 5)

    }
}

#Preview("Separator") { DisplaySeparator() }

struct LittleWhiteCircle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3.5)
            .padding(0.0)
            .frame(width: 7.0, height: 7.0)
            .foregroundColor(Color(white: 0.7))
    }
}

#Preview("WhiteCircle") { LittleWhiteCircle() }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. takes a string and converts "_" to faded "8" ..                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
@MainActor
func adjustDisplay(_ text: String) -> AttributedString {

    var attrText = AttributedString()

    for byte in text {
        var attrByte = AttributedString(String(byte))
        if (byte == "_") || !model.elPowerOn {
            attrByte = AttributedString("8")
            attrByte.foregroundColor = Color(white: 0.37)
        } else {
            attrByte.foregroundColor = displayElectro
        }
        attrText += attrByte
    }

    return attrText
}
