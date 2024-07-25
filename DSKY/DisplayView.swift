//
//  DisplayView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Row1                                                                                             ┆
  ┆ Spacer(12)                                                                                       ┆
  ┆ Row2                                                                                             ┆
  ┆ Reg1                                                                                             ┆
  ┆ Reg2                                                                                             ┆
  ┆ Reg3                                                                                             ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct DisplayView: View {
    let model = DisKeyModel.shared

    var body: some View {
        ZStack {
            PanelsView()
//            Image("Display").cornerRadius(8.0)

            VStack {
                Row1(comp: model.comp, prog: model.prog)
                Spacer().frame(height: 12.0)
                Row2(verb: model.verb, noun: model.noun)
                Register1(state: model.register1)
                Register2(state: model.register2)
                Register3(state: model.register3)
            }
        }
    }
}

#Preview {
    DisplayView()
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ROW1                                                                                             │
        "COMP"  default OFF, illuminated briefly by AGC
                it has no NUMBER ..
        "PROG"  default ON
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆    | "COMP" |   | "PROG" |     <-- placard: ("COMP", off at power-up - on under command)         ┆
  ┆    |        |   +--------+                  ("PROG", on at power-up))                            ┆
  ┆    |        |   +--------+                                                                       ┆
  ┆    |        |   |        |     <-- numbers: ( "99" , off/on, height)                             ┆
  ┆    |        |   |   99   |                                                                       ┆
  ┆    |        |   |        |                                                                       ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Row1: View {
    var comp: Display = ("  ", false)
    var prog: Display = ("  ", false)

    var body: some View {
        HStack(alignment: .top) {
            Comp(state: comp)
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
                           height: 60.0)
            DisplayNumbers(value: "  ")
        }
    }
}

struct Prog: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "PROG")
            DisplayNumbers(value: state.0)
        }
    }
}

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ROW2                                                                                             │
        "VERB"  default ON, turned OFF (or flashed?) as an entry prompt
        "NOUN"  default ON, turned OFF (or flashed?) as an entry prompt
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆    | "VERB" |   | "NOUN" |     <-- placard: ("VERB", on at power-up, flash)                      ┆
  ┆    +--------+   +--------+                  ("NOUN", on at power-up, flash)                      ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆    |        |   |        |     <-- numbers: ( "99" , off/on, height)                             ┆
  ┆    |   99   |   |   99   |                           flash                                       ┆
  ┆    |        |   |        |                                                                       ┆
  ┆    +--------+   +--------+                                                                       ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
struct Row2: View {
    var verb: Display = ("--", false)
    var noun: Display = ("--", false)

//    private let timer = Timer.publish(every: 0.5,
//                                      on: .main,
//                                      in: .common).autoconnect()

    var body: some View {
        HStack {
            Verb(state: verb)
            Noun(state: noun)
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row2()
}

struct Verb: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "VERB", illum: state.1)
            DisplayNumbers(value: state.0)
        }
    }
}

struct Noun: View {
    var state: Display

    var body: some View {
        VStack {
            DisplayPlacard(label: "NOUN", illum: state.1)
            DisplayNumbers(value: state.0)
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
        DisplayNumbers(value: state.0)
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
        DisplayNumbers(value: state.0)
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
        DisplayNumbers(value: state.0)
    }
}

struct DisplayPlacard: View {
    var label: String                   // placard label: "COMP", "PROG", "VERB", "NOUN"
    var illum: Bool = true              // illuminate the background (green)
    var height: CGFloat = 18.0          // the height of the placatf

    var body: some View {
        ZStack {
            if illum {
                RoundedRectangle(cornerRadius: 4.0)
                    .frame(width: 74.0, height: height)
                    .foregroundColor(displayElectro)

                Text(label)
                    .font(.custom("Gorton-Normal-180",
                                  fixedSize: 10))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4.0)
            } else {
                RoundedRectangle(cornerRadius: 4.0)
                    .frame(width: 74.0, height: height)
                    .foregroundColor(.clear)

                Text(label)
                    .font(.custom("Gorton-Normal-180",
                                  fixedSize: 12))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4.0)
            }
        }
    }
}

#Preview {
    DisplayPlacard(label: "WORD")
}

struct DisplayNumbers: View {
    var value: String

    var body: some View {

        switch value.count {
            case 6:
                VStack {
                    DisplaySeparator()

                    if value.starts(with: " ") {
                        Text(adjustDisplay(String(value.dropFirst())))
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
                        Text(adjustDisplay(String(value)))
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding(.all, -10.0)
                            .tracking(zerlinaTracking)
                            .frame(width: 190.0,
                                   height: panelDigitSize)
                    }
                }
            case 2:
                if value == "  " {
                    Text(value)
                        .frame(width: 95.0, height: 2.0)
                } else {
                    Text(adjustDisplay(String(value)))
                        .font(.custom("Zerlina",
                                      fixedSize: zerlinaFixedSize))
                        .padding(.top, 8.0)
                        .tracking(zerlinaTracking)
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

#Preview {
    DisplayNumbers(value: "614121")
}

#Preview {
    ZStack {
        PanelsView(interiorFill: .black)

        Rectangle()
            .border(Color.white, width: 1)
            .padding(8.0)
            .frame(width: 204,
                   height: 140)
            .foregroundColor(.clear)

        VStack {
            Register1(state: ("+88888", true))
            Register2(state: ("-88888", false))
        }
    }
}
