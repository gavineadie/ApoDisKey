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
                Register1(digits: "+01344")
                Register2(digits: " 01234")
                Register3(digits: "-56789")
            }
        }
    }
}

#Preview {
    DisplayView()
}

struct Comp: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayGreenText(word: "COMP\nACTY",
                             height: 60.0,
                             green: false)
            DisplayText(words: "  ")
        }
    }
}

struct Prog: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayGreenText(word: "PROG")
            DisplayText(words: digits)
        }
    }
}

struct Verb: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayGreenText(word: "VERB")
            DisplayText(words: digits)
        }
    }
}

struct Noun: View {
    var digits: String

    var body: some View {
        VStack {
            DisplayGreenText(word: "NOUN")
            DisplayText(words: digits)
        }
    }
}

struct Register1: View {
    var digits: String

    var body: some View {
        DisplayText(words: digits)
    }
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

struct Register2: View {
    var digits: String

    var body: some View {
        DisplayText(words: digits)
    }
}

struct Register3: View {
    var digits: String

    var body: some View {
        DisplayText(words: digits)
    }
}

struct Row1: View {
    var comp: String = "  "
    var prog: String = "--"

    var body: some View {
        HStack(alignment: .top) {
            Comp(digits: "  ")
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
