//
//  DisplayView.swift
//  DSKY
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
//    let model = DisKeyModel.shared

    var body: some View {
        ZStack {
            PanelsView()

            VStack {
                Row1(comp: model.comp, prog: model.prog)
                Spacer().frame(height: 12.0)
                Row2(verb: model.verb, noun: model.noun)
                Register1(state: model.reg1)
                Register2(state: model.reg2)
                Register3(state: model.reg3)
            }
        }
    }
}

#Preview {
    DisplayView()
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
  ┆    | "COMP" |   <-- placard: ("COMP", off at power-up - on under command)          | "PROG" |    ┆
  ┆    |        |                          placard: ("PROG", on at power-up)) -->      +--------+    ┆
  ┆    |        |                                                                      +--------+    ┆
  ┆    |        |                           numbers: ( "99" , off/on, height) -->      |        |    ┆
  ┆    |        |                                                                      |   99   |    ┆
  ┆    +--------+                                                                      |        |    ┆
  ┆    +--------+   <-- numbers: ("COMP", height = 0)                                  +--------+    ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Row1: View {
    var comp: Display = ("  ", false)
    var prog: Display = ("  ", false)

    var body: some View {
        HStack(alignment: .top) {
            Comp(state: comp)
                .padding(.trailing, 8.0)
            Prog(state: prog)
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row1()
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
    var verb: Display = ("88", false)
    var noun: Display = ("44", true)

    var body: some View {
        HStack {
            Verb(state: verb)
                .padding(.trailing, 8.0)
            Noun(state: noun)
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row2()
}

#Preview {
    VStack {
        Row1()
        Row2()
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

            RoundedRectangle(cornerRadius: 4.0)
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

#Preview {
    DisplayPlacard(label: "WORD")
}

struct DisplayNumbers: View {
    var value: Display

    var body: some View {

        switch value.0.count {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ REGISTER ..                                                                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            case 6:
                VStack {
                    DisplaySeparator()

                    if value.0.starts(with: " ") {
                        Text(adjustDisplay(String(value.0.dropFirst())))
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding([.top,
                                      .bottom,
                                      .trailing], -10.0)
                            .padding(.leading, 10.5)
                            .tracking(zerlinaTracking)
                            .frame(width: 190.0,
                                   height: panelDigitSize)
                    } else {
                        Text(adjustDisplay(String(value.0)))
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding(.all, -10.0)
                            .tracking(zerlinaTracking)
                            .frame(width: 190.0,
                                   height: panelDigitSize)
                    }
                }
            case 2:
                if value.0 == "  " {
                    Text(value.0)
                        .frame(width: 95.0, height: 2.0)
                } else {

                    if value.1 {
                        Text(adjustDisplay(String(value.0)))
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding(.top, 10.0)
                            .tracking(zerlinaTracking)
                            .frame(width: 95.0,
                                   height: panelDigitSize)
                    } else {
                        Text(value.0)
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .foregroundColor(panelInColor)
                            .padding(.top, 8.0)
                            .tracking(zerlinaTracking)
                            .frame(width: 95.0,
                                   height: panelDigitSize)
                    }
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

#Preview {
    DisplayNumbers(value: ("614121", true))
}

#Preview {
    ZStack {
        PanelsView(interiorFill: .black)

        Rectangle()
            .border(Color.white, width: 1)
            .padding(8.0)
            .frame(width: 204, height: 194)
            .foregroundColor(.clear)

        VStack {
            Register1(state: ("+88888", true))
            Register2(state: ("-88888", false))
            Register3(state: (" 99999", false))
        }
    }
}
