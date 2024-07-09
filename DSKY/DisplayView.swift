//
//  DisplayView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct DisplayView: View {
    var body: some View {
        ZStack {
            PanelsView(interiorFill: .black)
 //           Image("Display").cornerRadius(8.0)

            VStack {
                Row1(prog: "11")
                Spacer().frame(height: 12.0)
                Row2(verb: "06", noun: "62")
                DisplayText(words: "+01344")
                DisplayText(words: "+00085")
                DisplayText(words: "+00001")
            }
        }
    }
}

#Preview {
    DisplayView()
}

struct Row1: View {
    var comp: String = "  "
    var prog: String = "--"

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                DisplayGreenText(word: "COMP\nACTY",
                                 height: 60.0,
                                 green: false)
                DisplayText(words: comp)
            }

            VStack {
                DisplayGreenText(word: "PROG")
                DisplayText(words: prog)
            }
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
            VStack {
                DisplayGreenText(word: "VERB")
                DisplayText(words: verb)
            }

            VStack {
                DisplayGreenText(word: "NOUN")
                DisplayText(words: noun)
            }
        }
        .padding(.bottom, 6.0)
    }
}

#Preview {
    Row2()
}

struct DisplayText: View {
    var words: String

    var body: some View {

        switch words.count {
            case 6:
                VStack {
                    DisplaySeparator()

                    Text(words)
                        .font(.custom("Zerlina",
                                      fixedSize: zerlinaFixedSize))
                        .padding(.all, -10.0)
                        .tracking(zerlinaTracking)
                        .foregroundColor(.green)
                        .frame(width: 190.0,
                               height: panelDigitSize)
                }
            case 2:
                if words == "  " {
                    Text(words)
                        .frame(width: 95.0, height: 2.0)
                } else {
                    Text(words)
                        .font(.custom("Zerlina",
                                      fixedSize: zerlinaFixedSize))
                        .padding(.top, 8.0)
                        .tracking(zerlinaTracking)
                        .foregroundColor(.green)
                        .frame(width: 95.0,
                               height: panelDigitSize)
                }
            default:
                Text("ERROR")
                    .font(.custom("Zerlina",
                                  fixedSize: zerlinaFixedSize))
                    .tracking(zerlinaTracking)
                    .foregroundColor(.green)
                    .frame(width: 190.0,
                           height: panelDigitSize)
        }
    }
}

#Preview {
    DisplayText(words: "614121")
}

struct DisplayGreenText: View {
    var word: String
    var height: CGFloat = 18.0
    var green: Bool = true

    var body: some View {
        ZStack {
            if green {
                RoundedRectangle(cornerRadius: 4.0)
                    .frame(width: 74.0, height: height)
                    .foregroundColor(.green)

                Text(word)
                    .font(.custom("Gorton-Normal-180",
                                  fixedSize: 10))
                    .foregroundColor(.black)
            } else {
                RoundedRectangle(cornerRadius: 4.0)
                    .frame(width: 74.0, height: height)
                    .foregroundColor(.clear)

                Text(word)
                    .font(.custom("Gorton-Normal-180",
                                  fixedSize: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4.0)
            }
        }
    }
}

#Preview {
    DisplayGreenText(word: "WORD")
}
