//
//  StatusView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct StatusView: View {
    var body: some View {
        ZStack {
            PanelsView()

            Grid {
                GridRow {
                    StatusLightView(words: "UPLINK\nACTY")
                    StatusLightView(words: "TEMP")
                }

                GridRow {
                    StatusLightView(words: "NO ATT")
                    StatusLightView(words: "GIMBAL\nLOCK")
                }

                GridRow {
                    StatusLightView(words: "STBY")
                    StatusLightView(words: "PROG")
                }

                GridRow {
                    StatusLightView(words: "KEY REL")
                    StatusLightView(words: "RESTART")
                }

                GridRow {
                    StatusLightView(words: "OPR ERR")
                    StatusLightView(words: "TRACKER")
                }

                GridRow {
                    StatusLightView(words: "")
                    StatusLightView(words: "ALT")
                }

                GridRow {
                    StatusLightView(words: "")
                    StatusLightView(words: "VEL")
                }
            }
        }
    }
}

#Preview {
    StatusView()
}

struct StatusLightView: View {
    var words: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: statusCorner)
                .fill(Color(.white))
                .border(Color(statusBorder), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .frame(width: statusWidth, 
                       height: statusHeight)

            Text(words)
                .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                .fontWeight(.medium)
                .foregroundColor(Color(.black))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(-4.0)
        }
    }
}

#Preview {
    StatusLightView(words: "WORDS")
}
