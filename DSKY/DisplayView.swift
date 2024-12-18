//
//  DisplayView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

/*
            ┌───────────────────────┐
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆ "COMP" ┆ ┆ "PROG" ┆ │
            │ ┆        ┆ ┆        ┆ │
            │ ┆        ┆ ┆        ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆ "VERB" ┆ ┆ "NOUN" ┆ │
            │ ┆        ┆ ┆        ┆ │
            │ ┆        ┆ ┆        ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
            │ ┆ REGISTER1         ┆ │
            │ ┆                   ┆ │
            │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
            │ ┆ REGISTER2         ┆ │
            │ ┆                   ┆ │
            │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮ │
            │ ┆ REGISTER3         ┆ │
            │ ┆                   ┆ │
            │ ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯ │
            └───────────────────────┘
*/

struct DisplayView: View {

    var body: some View {
        ZStack {
            PanelsView()

            VStack {
                ZStack {
                    VStack {
                        Row1(comp: model.comp, prog: model.prog)
                        Spacer().frame(height: 12.0)
                        Row2(verb: model.verb, noun: model.noun)
                        Spacer().frame(height: 12.0)
                    }
                    VStack {
                        Spacer().frame(height: 10)
                        LittleWhiteCircle()
                        Spacer().frame(height: 60)
                        LittleWhiteCircle()
                        Spacer().frame(height: 60)
                        LittleWhiteCircle()
                        Spacer().frame(height: 20)
                    }
                }
                Register(state: model.reg1)
                Register(state: model.reg2)
                Register(state: model.reg3)
            }
        }
        .padding(.leading, 18.0)
    }
}

#Preview("Display") { DisplayView() }

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ROW1                                                                                             │
  │     "COMP"  default OFF, illuminated briefly by AGC                                              │
  │             it has no NUMBER ..                                                                  │
  │     "PROG"  default ON                                                                           │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆    +--------+                                                                      +--------+    ┆
  ┆    | "COMP  |   <-- placard: ("COMP", off at power-up - on under command)          | "PROG" |    ┆
  ┆    |  ACTY" |                          placard: ("PROG", on at power-up)) -->      +--------+    ┆
  ┆    |        |                                                                      +--------+    ┆
  ┆    |        |                           numbers: ( "99" , off/on, height) -->      |        |    ┆
  ┆    |        |                                                                      |   99   |    ┆
  ┆    +--------+                                                                      |        |    ┆
  ┆    +--------+   <-- numbers: ("COMP", height = 0)                                  +--------+    ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Row1: View {
    var comp: Display = ("  ", false)
    var prog: Display = ("__", false)

    var body: some View {
        HStack(alignment: .top) {
            Comp(state: comp)
            twoDigit(label: "PROG", value: prog)
        }
        .padding(.bottom, 6.0)
    }
}

struct Comp: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "COMP\nACTY",
                           power: model.elPowerOn && state.1,
                           placardHeight: 60.0)
            DisplayNumbers(value: ("  ", false))
        }
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ROW2                                                                                             │
  │     "VERB"  default ON, turned OFF (or flashed?) as an entry prompt                              │
  │     "NOUN"  default ON, turned OFF (or flashed?) as an entry prompt                              │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆    | "VERB" |   | "NOUN" |     <-- placard: ("VERB", on at power-up)                             ┆
  ┆    +--------+   +--------+                  ("NOUN", on at power-up)                             ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆    |        |   |        |     <-- numbers: ( "99" , off/on, height)                             ┆
  ┆    |   99   |   |   99   |                           flash                                       ┆
  ┆    |        |   |        |                                                                       ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Row2: View {
    var verb: Display = ("__", false)
    var noun: Display = ("__", false)

    var body: some View {
        HStack {
            twoDigit(label: "VERB", value: verb)
            twoDigit(label: "NOUN", value: noun)
        }
        .padding(.bottom, 6.0)
    }
}

struct twoDigit: View {
    var label: String
    var value: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: label,
                           power: model.elPowerOn)
            DisplayNumbers(value: value)
        }
    }
}

struct DisplayPlacard: View {
    var label: String                   // placard label: "COMP", "PROG", "VERB", "NOUN"
    var power: Bool = true              // illuminate the background (green)
    var placardHeight: CGFloat = 20.0   // the height of the placard

    var body: some View {
        ZStack {
            let placardColor = power ? displayElectro : .clear

            RoundedRectangle(cornerRadius: 3.0)
                .frame(width: 74.0, height: placardHeight)
                .foregroundColor(placardColor)

            Text(label)
                .font(.custom("Gorton-Normal-180", fixedSize: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineSpacing(4.0)
        }
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ REGISTER                                                                                         │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ +---------------------------+                                                                    ┆
  ┆ |  +---------------------+  |                                                                    ┆
  ┆ |  +--------+ | +--------+  |                                                                    ┆
  ┆ |  |        | | |        |  |                                                                    ┆
  ┆ |  | +77777 | | | +77777 |  |  <-- numbers: ( "99" , off/on, height)                             ┆
  ┆ |  |        | | |        |  |                                                                    ┆
  ┆ |  +--------+ | +--------+  |                                                                    ┆
  ┆ +---------------------------+                                                                    ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Register: View {
    var state: Display

    var body: some View {
        DisplayNumbers(value: state)
    }
}

#Preview("Register") { Register(state: Display(label: "+89999", off: true)) }

struct DisplayNumbers: View {
    var value: Display

    var body: some View {

        switch value.0.count {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ REGISTER .. "±ddddd" (decimal)  OR  " ddddd" (octal)                                             ┆
  ┆     since the " " character width in this font is different from the "+" and "-" characters, it  ┆
  ┆     needs to accounted for by removing it and moving the remaining five digits slightly left.    ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            case 6:
                VStack {
                    DisplaySeparator()

                    if #available(macOS 13.0, *) {
                        Text(adjustDisplay(value.0))
                            .sevenSegRegister()
                            .kerning(4.0)
                   } else {
                       Text(adjustDisplay(value.0))
                           .sevenSegRegister()
                    }
                }
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ COMP / PROG / VERB / NOUN ..                                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            case 2:
                if value.0 == "  " {            // for "COMP" -- (tall frame) no number to display ..
                    Text(value.0)
                        .frame(width: 95.0, height: 2.0)
                } else {
                    if #available(macOS 13.0, *) {
                        Text(adjustDisplay(value.1 ? value.0 : "__"))
                            .sevenSegVerbNoun()
                            .kerning(4.0)
                    } else {
                        Text(adjustDisplay(value.1 ? value.0 : "__"))
                            .sevenSegVerbNoun()
                    }
                }
            default:
                Text("--------")
                    .font(.custom("Zerlina", fixedSize: zerlinaFixedSize))
                    .kerning(4.0)
                    .foregroundColor(.red)
                    .frame(width: 95.0, height: panelDigitSize)
        }
    }
}


extension View {
    func sevenSegRegister() -> some View {
        modifier(SevenSegRegister())
    }
}

struct SevenSegRegister: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Zerlina", fixedSize: zerlinaFixedSize))
            .padding(.all, -10.0)
            .frame(width: 190.0, height: panelDigitSize)
    }
}

extension View {
    func sevenSegVerbNoun() -> some View {
        modifier(SevenSegVerbNoun())
    }
}

struct SevenSegVerbNoun: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Zerlina", fixedSize: zerlinaFixedSize))
            .padding(.top, 8.0)
            .frame(width: 95.0, height: panelDigitSize)
    }
}
