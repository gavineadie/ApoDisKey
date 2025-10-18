//
//  StatusView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul07/24 (copyright 2024-25)
//

import SwiftUI

/*
            ┌───────────────────────┐
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮<--- exterior color (edge)
            │ ┆ UPLINK ┆ ┆  TEMP  ┆ │
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │   interior color: Color(white: 0.6)
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
            PanelsView(interiorFill: Color(white: 0.6))

            if #available(macOS 13.0, *) {
                Grid {
                    GridRow {
                        AnnunciatorLamp(light: model.lights[11]!)
                        AnnunciatorLamp(light: model.lights[21]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[12]!)
                        AnnunciatorLamp(light: model.lights[22]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[13]!)
                        AnnunciatorLamp(light: model.lights[23]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[14]!)
                        AnnunciatorLamp(light: model.lights[24]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[15]!)
                        AnnunciatorLamp(light: model.lights[25]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[16]!)
                        AnnunciatorLamp(light: model.lights[26]!)
                    }
                    GridRow {
                        AnnunciatorLamp(light: model.lights[17]!)
                        AnnunciatorLamp(light: model.lights[27]!)
                    }
                }
            } else {
                VStack {
                    HStack {
                        AnnunciatorLamp(light: model.lights[11]!)
                        AnnunciatorLamp(light: model.lights[21]!)
                    }

                    HStack {
                        AnnunciatorLamp(light: model.lights[12]!)
                        AnnunciatorLamp(light: model.lights[22]!)
                    }

                    HStack {
                        AnnunciatorLamp(light: model.lights[13]!)
                        AnnunciatorLamp(light: model.lights[23]!)
                    }
                    HStack {
                        AnnunciatorLamp(light: model.lights[14]!)
                        AnnunciatorLamp(light: model.lights[24]!)
                    }
                    HStack {
                        AnnunciatorLamp(light: model.lights[15]!)
                        AnnunciatorLamp(light: model.lights[25]!)
                    }
                    HStack {
                        AnnunciatorLamp(light: model.lights[16]!)
                        AnnunciatorLamp(light: model.lights[26]!)
                    }

                    HStack {
                        AnnunciatorLamp(light: model.lights[17]!)
                        AnnunciatorLamp(light: model.lights[27]!)
                    }
                }
            }
        }
        .padding(.trailing, 18.0)
    }
}

#if swift(>=5.9)
#Preview("Status") { StatusView() }
#endif

/*
            ┌───────────────────────┐
            ┆           <-------------- interior color: Color(white: 0.6)
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆  STBY  ┆ ┆  PROG  ┆<--- border color: Color(white: 0.5)
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            │ ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮ │
            │ ┆KEY REL ┆ ┆    <-------- lamp color OFF: Color(white: 0.55)
            │ ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯ │
            ┆                       ┆
            └───────────────────────┘
*/

struct AnnunciatorLamp: View {
    var light: Lamp

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: statusCorner)
                .fill(back(light))
                .border(Color(white: 0.5), width: 1.5)
                .frame(width: statusWidth, height: statusHeight)
                .padding(.vertical, lampVerticalPadding)
                .padding(.horizontal, +2)

            Text(light.0)
                .font(.custom("Gorton-Normal-180", fixedSize: 12.5))
                .baselineOffset(-2.0)
                .foregroundColor(light.1 == .off ? .black : statusText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(4.0)
        }
    }
}

#if swift(>=5.9)
#Preview("OFF") { AnnunciatorLamp(light: ("WORDS", .off)) }
#Preview("YELLOW") { AnnunciatorLamp(light: ("WORDS", .yellow)) }
#Preview("WHITE") { AnnunciatorLamp(light: ("WORDS", .white)) }
#endif

private func back(_ input: (String, BackColor)) -> Color {
    if model.elPowerOn {
        switch input.1 {
            case .off:      return Color(white: 0.55)
            case .white:    return .white
            case .green:    return .green
            case .yellow:   return .yellow
            case .orange:   return .orange
            case .red:      return .red
        }
    } else {
        return .gray
    }
}
