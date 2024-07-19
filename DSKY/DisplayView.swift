//
//  DisplayView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct DisplayView: View {
    let model = DisKeyModel.shared

    var body: some View {
        ZStack {
            PanelsView()
//            Image("Display").cornerRadius(8.0)

            VStack {
                Row1(comp: model.comp, prog: model.prog.0)
                Spacer().frame(height: 12.0)
                Row2(verb: model.verb.0, noun: model.noun.0)
                Register1(digits: model.register1.0)
                Register2(digits: model.register2.0)
                Register3(digits: model.register3.0)
            }
        }
    }
}

#Preview {
    DisplayView()
}

struct Comp: View {
    var state: Display
    var body: some View {
        VStack {
            DisplayLight(label: "COMP\nACTY",
                         green: state.1,
                         height: 60.0)
            DisplayValue(value: "  ")
        }
    }
}

struct Prog: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayLight(label: "PROG")
            DisplayValue(value: digits)
        }
    }
}

struct Verb: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayLight(label: "VERB")
            DisplayValue(value: digits)
        }
    }
}

struct Noun: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayLight(label: "NOUN")
            DisplayValue(value: digits)
        }
    }
}

struct Register1: View {
    var digits: String

    var body: some View {
        DisplayValue(value: digits)
    }
}

struct Register2: View {
    var digits: String

    var body: some View {
        DisplayValue(value: digits)
    }
}

struct Register3: View {
    var digits: String

    var body: some View {
        DisplayValue(value: digits)
    }
}

struct DisplayValue: View {
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
    DisplayValue(value: "614121")
}


struct Row1: View {
    var comp: Display = ("  ", false)
    var prog: String = "--"

    var body: some View {
        HStack(alignment: .top) {
            Comp(state: comp)
            Prog(digits: prog)
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row1()
}

struct Row2: View {
    var verb: String = "--"
    var noun: String = "--"

    var body: some View {
        HStack {
            Verb(digits: verb)
            Noun(digits: noun)
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row2()
}

struct DisplayLight: View {
    var label: String
    var green: Bool = true
    var height: CGFloat = 18.0

    var body: some View {
        ZStack {
            if green {
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
    DisplayLight(label: "WORD")
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
            Register1(digits: "+88888")
            Register2(digits: " 88888")
        }
    }
}

private func back(_ input: (String, BackColor)) -> Color {
    switch input.1 {
        case .on:
            return .white
        default:
            return .gray
    }
}

private func text(_ input: (String, BackColor)) -> String {
    input.0
}
