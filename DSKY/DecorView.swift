//
//  DecorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/9/24.
//

import SwiftUI

let keyPadSize: CGFloat = 73
let keyPadding: CGFloat = -2
let keyCorner: CGFloat = 3

let panelExSizeW: CGFloat = 222
let panelExSizeH: CGFloat = 374

let panelInset: CGFloat = 26
let panelDigitSize: CGFloat = 37

let statusWidth: CGFloat = 90
let statusHeight: CGFloat = 44
let statusCorner: CGFloat = 6

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
    }
}

struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelsView()
    }
}

struct DisplaySeparator: View {
    var body: some View {
        HStack {
            LittleWhiteCircle()

            RoundedRectangle(cornerRadius: 1)
                    .padding(.horizontal, -4.0)
                    .frame(height: 4.0)
                    .foregroundColor(model.elPanelOff ? .clear : displayElectro)

            LittleWhiteCircle()
        }
        .frame(width: 192,
               height: 5)

    }
}

struct DisplaySeparator_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySeparator()
    }
}

struct LittleWhiteCircle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3.5)
            .padding(0.0)
            .frame(width: 7.0, height: 7.0)
            .foregroundColor(Color(white: 0.7))
    }
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. takes a string and converts "_" to faded "8" ..                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func adjustDisplay(_ text: String) -> AttributedString {

    var attrText = AttributedString()

    for byte in text {
        var attrByte = AttributedString(String(byte))
        if byte == "_" {
            attrByte = AttributedString("8")
            attrByte.foregroundColor = Color(white: 0.34)
        } else {
            attrByte.foregroundColor = displayElectro
        }
        attrText += attrByte
    }

    return attrText
}
