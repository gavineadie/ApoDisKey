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
      //      Image("Display").cornerRadius(8.0)

            VStack {

                HStack(alignment: .top) {

                    VStack {
                        DisplayGreenText(word: "COMP\nACTY", height: 60.0)
                        DisplayText(words: "  ")
                    }

//                    LittleWhiteCircle()

                    VStack {
                        DisplayGreenText(word: "PROG")
                        DisplayText(words: "00")
                    }
                }
//                .padding(.top, 60.0)
                .padding(/*@START_MENU_TOKEN@*/.bottom, 0.0/*@END_MENU_TOKEN@*/)
                

                HStack {
                    VStack {
                        DisplayGreenText(word: "VERB")
                        DisplayText(words: "00")
                    }

//                    LittleWhiteCircle()

                    VStack {
                        DisplayGreenText(word: "NOUN")
                        DisplayText(words: "01")
                    }
                }

                DisplayText(words: "+60228")

                DisplayText(words: "-00001")

                DisplayText(words: "+00001")
            }
        }

    }
}

#Preview {
    DisplayView()
}

struct DisplayText: View {
    var words: String

    var body: some View {

        switch words.count {
            case 6:
                VStack {
                    DisplaySeparator()

                    Text(words)
                        .font(.custom("Zerlina", fixedSize: 48))
                        .padding(.all, -10.0)
                        .tracking(2.0)
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
                        .font(.custom("Zerlina", fixedSize: 48))
                        .tracking(2.0)
                        .foregroundColor(.green)
                        .frame(width: 95.0, 
                               height: panelDigitSize)
                }
            default:
                Text("ERROR")
                    .font(.custom("Zerlina", fixedSize: 48))
                    .tracking(2.0)
                    .foregroundColor(.green)
                    .frame(width: 190.0, 
                           height: panelDigitSize)
        }
    }
}

#Preview {
    DisplayText(words: "XXXX")
}

struct DisplayGreenText: View {
    var word: String
    var height: CGFloat = 20.0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .frame(width: 74.0, height: height)
                .foregroundColor(.green)

            Text(word)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(-4.0)
        }
    }
}

#Preview {
    DisplayGreenText(word: "WORD")
}

struct DisplaySeparator: View {
    var body: some View {
        HStack {
            LittleWhiteCircle()

            Rectangle()
                .frame(width: 150, 
                       height: 4)
                .foregroundColor(.green)

            LittleWhiteCircle()
        }

    }
}

#Preview {
    DisplaySeparator()
}

struct LittleWhiteCircle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 4.0)
            .frame(width: 10.0, height: 8.0)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
