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

    @StateObject var model = DisKeyModel.shared

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
                Register1(state: model.reg1)
                Register2(state: model.reg2)
                Register3(state: model.reg3)
            }
        }
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}

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
    var prog: Display = ("__", true)

    var body: some View {
        HStack(alignment: .top) {
            Comp(state: comp)
            Prog(state: prog)
        }
        .padding(.bottom, 6.0)
    }
}

struct Row1_Previews: PreviewProvider {
    static var previews: some View {
        Row1()
    }
}

struct Comp: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "COMP\nACTY",
                           illum: state.1,
                           placardHeight: 60.0)
            DisplayNumbers(value: ("  ", false))
        }
    }
}

struct Prog: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "PROG")
            DisplayNumbers(value: state)
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
    var verb: Display = ("__", true)
    var noun: Display = ("88", true)

    var body: some View {
        HStack {
            Verb(state: verb)
            Noun(state: noun)
        }
        .padding(.bottom, 6.0)
    }
}

struct Verb: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "VERB")
            DisplayNumbers(value: state)
        }
    }
}

struct Noun: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "NOUN")
            DisplayNumbers(value: state)
                .padding(.trailing, -1.0)
        }
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ REGISTER1                                                                                        │
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
struct Register1: View {
    var state: Display

    var body: some View {
        DisplayNumbers(value: state)
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ REGISTER2                                                                                        │
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
struct Register2: View {
    var state: Display

    var body: some View {
        DisplayNumbers(value: state)
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ REGISTER3                                                                                        │
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
struct Register3: View {
    var state: Display

    var body: some View {
        DisplayNumbers(value: state)
    }
}

struct DisplayPlacard: View {
    var label: String                   // placard label: "COMP", "PROG", "VERB", "NOUN"
    var illum: Bool = true              // illuminate the background (green)
    var placardHeight: CGFloat = 20.0   // the height of the placard

    var body: some View {
        ZStack {
            let placardColor = illum ? displayElectro : .clear

            RoundedRectangle(cornerRadius: 3.0)
                .frame(width: 74.0, height: placardHeight)
                .foregroundColor(placardColor)

            Text(label)
                .font(.custom("Gorton-Normal-180",
                              fixedSize: 12))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineSpacing(4.0)

        }
    }
}

struct DisplayPlacard_Previews: PreviewProvider {
    static var previews: some View {
        DisplayPlacard(label: "WORD")
    }
}

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

                    Text(adjustDisplay(value.0.starts(with: " ") ?
                                       String(value.0.dropFirst()) : value.0))
                        .font(.custom("Zerlina",
                                      fixedSize: zerlinaFixedSize))
                        .padding(.all, -10.0)
                        .padding(.leading, value.0.starts(with: " ") ? 10.5 : -10.0)
 //###                  .tracking(zerlinaTracking)
                        .frame(width: 190.0,
                               height: panelDigitSize)
                }
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ COMP / PROG / VERB / NOUN ..                                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            case 2:
                if value.0 == "  " {            // for "COMP" -- (tall frame) no number to display ..
                    Text(value.0)
                        .frame(width: 95.0, height: 2.0)
                } else {
                    Text(adjustDisplay(value.1 ? String(value.0) : "  "))
                        .font(.custom("Zerlina",
                                      fixedSize: zerlinaFixedSize))
                        .padding(.top, 8.0)
//###                   .tracking(zerlinaTracking)
                        .frame(width: 95.0,
                               height: panelDigitSize)
                }
            default:
                Text("ERROR")
                    .font(.custom("Zerlina",
                                  fixedSize: zerlinaFixedSize))
                    .tracking(zerlinaTracking)
                    .foregroundColor(displayElectro)
                    .frame(width: 190.0,
                           height: panelDigitSize)
        }
    }
}
