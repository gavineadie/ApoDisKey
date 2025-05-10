//
//  DecorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul09/24 (copyright 2024-25)
//

import SwiftUI

// panel dimensions

let panelExSizeW: CGFloat = 222.0
var panelExSizeH: CGFloat {
    if #available(macOS 13.0, *) {
        return 374.0 - 2.0
    } else {
        return 374.0
    }
}
let panelInset: CGFloat = 26.0
var panelPaddingTop: CGFloat {
    if #available(macOS 13.0, *) {
        return 10.0
    } else {
        return 6.0
    }
}

// annunciator lamp panel dimensions

var lampVerticalPadding: CGFloat {
    if #available(macOS 13.0, *) {
        return +1.0
    } else {
        return -0.75
    }
}
var statusWidth: CGFloat {
    if #available(macOS 13.0, *) {
        return 90.0
    } else {
        return 90.0 - 2.0
    }
}
var statusHeight: CGFloat {
    if #available(macOS 13.0, *) {
        return 45.0
    } else {
        return 45.0 - 1.5
    }
}
let statusCorner: CGFloat = 6.0

let statusText = Color(white: 0.0)

// electro-luminescent display panel dimensions

let displayElectro = Color(red: 0.1, green: 0.8, blue: 0.1)

let keyTextColorLit = Color(white: 0.9)
let keyTextColorOff = Color(white: 0.7)
let keyPadColor = Color(white: 0.25)
var keyPadBaselineOffset: CGFloat {
    if #available(macOS 13.0, *) {
        return 0
    } else {
        return +2.0
    }
}
var keyPadPaddingTop: CGFloat {
    if #available(macOS 13.0, *) {
        return 16.0
    } else {
        return 12.0
    }
}

let zerlinaFixedSize: CGFloat = 46.0
let zerlinaTracking: CGFloat = 4.0

// keypad dimensions

let keyPadSize: CGFloat = 74.0
let keyPadding: CGFloat = -2.0
let keyCorner: CGFloat = 5.0

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

var panelTopPadding: CGFloat {
    if #available(macOS 13.0, *) {
        return 0
    } else {
        return 4
    }
}

struct PanelsView: View {
    var interiorFill: Color = Color(white: 0.6)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)              // outer
                .fill(Color(white: 0.60))
                .frame(width: panelExSizeW,
                       height: panelExSizeH)
                .shadow(color: Color.black.opacity(0.6),
                        radius: 1, x: 3, y: 2)

            RoundedRectangle(cornerRadius: 6)               // inner
                .fill(interiorFill)
                .frame(width: panelExSizeW-panelInset,
                       height: panelExSizeH-panelInset)
        }
        .padding(.top, panelTopPadding)
    }
}

#if swift(>=5.9)
#Preview("Panels") { PanelsView(interiorFill: .brown) }
#endif

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

#if swift(>=5.9)
#Preview("Separator") { DisplaySeparator() }
#endif

struct LittleWhiteCircle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3.5)
            .padding(0.0)
            .frame(width: 7.0, height: 7.0)
            .foregroundColor(Color(white: 0.7))
    }
}

#if swift(>=5.9)
#Preview("WhiteCircle") { LittleWhiteCircle() }
#endif

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. takes a string and converts "_" to faded "8" ..                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
@MainActor
func adjustDisplay(_ text: String) -> AttributedString {

    var attrText = AttributedString()
    let normText = model.elPowerOn ? text : text.count > 2 ? "+_____" : "__"

    for byte in normText {
        var attrByte = AttributedString(String(byte))
        switch byte {
            case "+", "-":
                attrByte = AttributedString(String(byte))
                attrByte.foregroundColor = model.elPowerOn ? displayElectro : .clear

            case "_":
                attrByte = AttributedString("8")
                attrByte.foregroundColor = Color(white: 0.37)

            default:
                attrByte.foregroundColor = displayElectro
        }
        attrText += attrByte
    }

    return attrText
}
