//
//  DecorView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/9/24.
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable switch_case_alignment

import SwiftUI

// panel dimensions

let panelExSizeW: CGFloat = 222.0
#if MONTEREY
let panelExSizeH: CGFloat = 374.0 - 2.0
#else
let panelExSizeH: CGFloat = 374.0
#endif
let panelInset: CGFloat = 26.0

// annunciator lamp panel dimensions

#if MONTEREY
let statusWidth: CGFloat = 90.0 - 2.0
let statusHeight: CGFloat = 45.0 - 1.5
#else
let statusWidth: CGFloat = 90.0
let statusHeight: CGFloat = 45.0
#endif
let statusCorner: CGFloat = 6.0

let statusText = Color(white: 0.0)

// electro-luminescent display panel dimensions

let displayElectro = Color(red: 0.1, green: 0.8, blue: 0.1)

let keyTextColor = Color(white: 0.9)
let keyPadColor = Color(white: 0.25)

#if MONTEREY
let keyPadBaselineOffset = -2.0
#else
let keyPadBaselineOffset = -4.0
#endif

let zerlinaFixedSize: CGFloat = 46.0
let zerlinaTracking: CGFloat = 4.0

// keypad dimensions

let keyPadSize: CGFloat = 73.0
let keyPadding: CGFloat = -2.0
let keyCorner: CGFloat = 3.0

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
    var interiorFill: Color = Color(white: 0.6)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)              // outer
                .fill(Color(white: 0.60))
                .frame(width: panelExSizeW,
                       height: panelExSizeH)
                .shadow(color: Color.black.opacity(0.6),
                        radius: 1.0,
                        x: 3.0, y: 3.0)

            RoundedRectangle(cornerRadius: 6)               // inner
                .fill(interiorFill)
                .frame(width: panelExSizeW-panelInset,
                       height: panelExSizeH-panelInset)
        }
#if MONTEREY
        .padding(.top, +4)
#endif
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
    let normText = model.elPowerOn ? text :
                    text.count > 2 ? "-_____" : "__"

    for byte in normText {
        var attrByte = AttributedString(String(byte))
        switch byte {
            case "+", "-":
                attrByte = AttributedString("+")
                if model.elPowerOn {
                    attrByte.foregroundColor = displayElectro
                } else {
                    attrByte.foregroundColor = .clear
                }

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
