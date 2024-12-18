//
//  StatusView.swift
//  ApoDisKey
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

    @ObservedObject var model = DisKeyModel.shared

    var body: some View {
        ZStack {
            PanelsView()

            if #available(macOS 13.0, *) {
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
            } else {
                VStack {
                    HStack {
                        StatusLight(light: model.statusLights[11]!)
                        StatusLight(light: model.statusLights[21]!)
                    }

                    HStack {
                        StatusLight(light: model.statusLights[12]!)
                        StatusLight(light: model.statusLights[22]!)
                    }

                    HStack {
                        StatusLight(light: model.statusLights[13]!)
                        StatusLight(light: model.statusLights[23]!)
                    }
                    HStack {
                        StatusLight(light: model.statusLights[14]!)
                        StatusLight(light: model.statusLights[24]!)
                    }
                    HStack {
                        StatusLight(light: model.statusLights[15]!)
                        StatusLight(light: model.statusLights[25]!)
                    }
                    HStack {
                        StatusLight(light: model.statusLights[16]!)
                        StatusLight(light: model.statusLights[26]!)
                    }

                    HStack {
                        StatusLight(light: model.statusLights[17]!)
                        StatusLight(light: model.statusLights[27]!)
                    }
                }
            }
        }
        .padding(.trailing, 18.0)
    }
}

struct StatusLight: View {
    var light: Light

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: statusCorner)
                .fill(back(light))
                .border(statusBorder, width: 1)
                .frame(width: statusWidth,
                       height: statusHeight+2.0)

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

@MainActor
private func back(_ input: (String, BackColor)) -> Color {
    if model.elPowerOn {
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
    } else {
        return .gray
    }
}
