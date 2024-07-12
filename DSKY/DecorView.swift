//
//  DecorView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/9/24.
//

import SwiftUI

struct PanelsView: View {
    var interiorFill: Color = panelInColor

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: panelExCorner)
                .fill(Color(panelExColor))
                .frame(width: panelExSizeW, height: panelExSizeH)

            RoundedRectangle(cornerRadius: panelInCorner)
                .fill(Color(interiorFill))
                .frame(width: panelExSizeW-panelInset,
                       height: panelExSizeH-panelInset)
        }
    }
}

#Preview {
    PanelsView(interiorFill: .pink)
}

struct DisplaySeparator: View {
    var body: some View {
        HStack {
            LittleWhiteCircle()

            Rectangle()
                .padding(.horizontal, -4.0)
                .frame(width: 144,
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
            .padding(0.0)
            .frame(width: 8.0, height: 8.0)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct DisplayText: View {
    var words: String

    var body: some View {

        switch words.count {
            case 6:
                VStack {
                    DisplaySeparator()

                    if words.starts(with: " ") {
                        Text(words.dropFirst())
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding([.top, 
                                .bottom,
                                .trailing], -10.0)
                            .padding(.leading, 10.5)
                            .tracking(zerlinaTracking)
                            .foregroundColor(.green)
                            .frame(width: 190.0,
                                   height: panelDigitSize)
                    } else {
                        Text(words)
                            .font(.custom("Zerlina",
                                          fixedSize: zerlinaFixedSize))
                            .padding(.all, -10.0)
                            .tracking(zerlinaTracking)
                            .foregroundColor(.green)
                            .frame(width: 190.0,
                                   height: panelDigitSize)
                    }
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

