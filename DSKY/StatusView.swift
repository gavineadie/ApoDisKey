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
                    StatusLight(light: statusArray[0])
                    StatusLight(light: statusArray[5])
                }

                GridRow {
                    StatusLight(light: statusArray[1])
                    StatusLight(light: statusArray[6])
                }

                GridRow {
                    StatusLight(light: statusArray[2])
                    StatusLight(light: statusArray[7])
                }

                GridRow {
                    StatusLight(light: statusArray[3])
                    StatusLight(light: statusArray[8])
                }

                GridRow {
                    StatusLight(light: statusArray[4])
                    StatusLight(light: statusArray[9])
                }

                GridRow {
                    StatusLight(light: ("", .off))
                    StatusLight(light: statusArray[10])
                }

                GridRow {
                    StatusLight(light: ("", .off))
                    StatusLight(light: statusArray[11])
                }
            }
        }
    }
}

#Preview {
    StatusView()
}

struct StatusLight: View {
    var light: (String, BackColor)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: statusCorner)
                .fill(back(light))
                .border(Color(statusBorder), width: 1)
                .frame(width: statusWidth,
                       height: statusHeight)

            Text(text(light))
                .font(.custom("Gorton-Normal-180",
                              fixedSize: 12))
                .baselineOffset(-2.0)
                .foregroundColor(statusText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(4.0)
        }
    }
}

#Preview {
    StatusLight(light: ("WORDS", .off))
}

#Preview {
    StatusLight(light: ("WORDS", .orange))
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
