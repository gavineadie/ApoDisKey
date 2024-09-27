//
//  StatusView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

/*
            ┌───────────────────────┐
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆ UPLINK ┆ ┆  TEMP  ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆ NO ATT ┆ ┆ GIMBAL ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆  STBY  ┆ ┆  PROG  ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆KEY REL ┆ ┆RESTART ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆OPR ERR ┆ ┆TRACKER ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆        ┆ ┆  ALT   ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆        ┆ ┆  VEL   ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            └───────────────────────┘
*/

struct StatusView: View {
    var body: some View {
        ZStack {
            PanelsView()

            Grid {
                GridRow {
                    StatusLight(light: model.statusLights[11]!)
                    StatusLight(light: model.statusLights[21]!)
                }

                GridRow {
                    StatusLight(light: model.statusLights[12]!)
                    StatusLight(light: model.statusLights[22]!)
                }

                GridRow {
                    StatusLight(light: model.statusLights[13]!)
                    StatusLight(light: model.statusLights[23]!)
                }
                GridRow {
                    StatusLight(light: model.statusLights[14]!)
                    StatusLight(light: model.statusLights[24]!)
                }
                GridRow {
                    StatusLight(light: model.statusLights[15]!)
                    StatusLight(light: model.statusLights[25]!)
                }
                GridRow {
                    StatusLight(light: model.statusLights[16]!)
                    StatusLight(light: model.statusLights[26]!)
                }

                GridRow {
                    StatusLight(light: model.statusLights[17]!)
                    StatusLight(light: model.statusLights[27]!)
                }
            }
        }
    }
}

#Preview {
    StatusView()
}


struct StatusLight: View {
    var light: Light

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: statusCorner)
                .fill(back(light))
                .border(Color(statusBorder), width: 1)
                .frame(width: statusWidth,
                       height: statusHeight)

            Text(light.0)
                .font(.custom("Gorton-Normal-180",
                              fixedSize: 12))
                .baselineOffset(-2.0)
                .foregroundColor(light.1 == .off ? .black : statusText)
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
        case .white:
            return .white
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .orange:
            return .orange
        case .red:
            return .red
        default:
            return .gray
    }
}
