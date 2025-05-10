//
//  KeyPadView.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul07/24 (copyright 2024-25)
//

import SwiftUI
import ApolloNetwork
import AVFoundation

/*
            ┌────────────────────────────────────────────────────┐
            │         ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮         │
            │         ┆+   ┆ ┆7   ┆ ┆8   ┆ ┆9   ┆ ┆CLR ┆         │
            │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
            │  ┆VERB┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆ENTR┆  │
            │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
            │  ╰╌╌╌╌╯ ┆-   ┆ ┆4   ┆ ┆5   ┆ ┆6   ┆ ┆PRO ┆ ╰╌╌╌╌╯  │
            │  ╭╌╌╌╌╮ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ╭╌╌╌╌╮  │
            │  ┆NOUN┆ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ┆RSET┆  │
            │  ┆    ┆ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ╭╌╌╌╌╮ ┆    ┆  │
            │  ╰╌╌╌╌╯ ┆0   ┆ ┆1   ┆ ┆2   ┆ ┆3   ┆ ┆KEY ┆ ╰╌╌╌╌╯  │
            │         ┆    ┆ ┆    ┆ ┆    ┆ ┆    ┆ ┆REL ┆         │
            │         ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯ ╰╌╌╌╌╯         │
            └────────────────────────────────────────────────────┘
*/

struct KeyPadView: View {

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                KeyView(keyCode: 17) // "VERB"
                KeyView(keyCode: 31) // "NOUN"
            }

            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    KeyView(keyCode: 26) //  "+"
                    KeyView(keyCode: 07) //  "7"
                    KeyView(keyCode: 08) //  "8"
                    KeyView(keyCode: 09) //  "9"
                    KeyView(keyCode: 30) //  "CLR"
                }

                HStack(alignment: .center) {
                    KeyView(keyCode: 27) //  "-"
                    KeyView(keyCode: 04) //  "4"
                    KeyView(keyCode: 05) //  "5"
                    KeyView(keyCode: 06) //  "6"
                    KeyView(keyCode: 99) //  "PRO" << cheat
                }

                HStack(alignment: .center) {
                    KeyView(keyCode: 16) //  "0"
                    KeyView(keyCode: 01) //  "1"
                    KeyView(keyCode: 02) //  "2"
                    KeyView(keyCode: 03) //  "3"
                    KeyView(keyCode: 25) //  "KEY REL"
                }
            }

            VStack(alignment: .center) {
                KeyView(keyCode: 28) // "ENTR"
                KeyView(keyCode: 18) // "RSET"
            }
        }
        .padding(.top, keyPadPaddingTop)
    }
}

#if swift(>=5.9)
#Preview("KeyPad") { KeyPadView() }
#endif

struct KeyView: View {
    var keyCode: UInt16

    var body: some View {
        let keyGlyph = keyText(keyCode)
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. single characters are ~28 points and words are ~12 points                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        let fontSize: CGFloat = model.fullSize ?
                                    (keyGlyph.count == 1 ? 24 : 11) : (keyGlyph.count == 1 ? 32 : 15)
        let fontName = keyGlyph.count == 1 ? "Gorton-Normal-120" : "Gorton-Normal-180"

        Text(keyGlyph)
            .font(.custom(fontName, fixedSize: fontSize))
            .baselineOffset(keyPadBaselineOffset)
            .foregroundColor(model.elPowerOn ? keyTextColorLit : keyTextColorOff)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .lineSpacing(4.0)
            .frame(width: keyPadSize,
                   height: keyPadSize)
            .background(keyPadColor)
            .padding(.all, keyPadding)
            .cornerRadius(keyCorner)
            .shadow(color: Color.white.opacity(0.3),
                    radius: 1, x: -1, y: -1)
#if os(macOS)
            .acceptClickThrough()
#endif
            .onTapGesture {
                if model.network.connection.state != .ready {
                    logger.log("any key press while network not ready ..")
                    startNetwork()
                }

                if keyCode < 99 {
                    logger.log("«««    \(keyText(keyCode).replacingOccurrences(of: "\n", with: " ")) (\(keyCode))")

                    if let clickURL = Bundle.main.url(forResource: "dsky", withExtension: "aiff") {
                        var clickSound: SystemSoundID = 0
                        AudioServicesCreateSystemSoundID(clickURL as CFURL, &clickSound)
                        AudioServicesPlaySystemSound(clickSound)
                    }
                    Task {
                        do {
                            try await model.network.send(formIoPacket(0o015, keyCode))
                        } catch {
                            logger.error("\(error.localizedDescription)")
                        }
                    }
                }
            }
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ the "PRO" key is a long press                                                                    ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged( { _ in
                        if keyCode == 99 {
                            let value: UInt16 = 0b0000_0000_0000_0000   // bit 14 - zero

                            logger.log("""
                                «««    DSKY 032:    \(zeroPadWord(value)) BITS (15)      \
                                :: \(keyText(keyCode)) ↓
                                """)
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ "PRO" key DOWN ..                                                                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                            Task {
                                do {
                                    try await model.network.send(formIoPacket(0o032, value))
                                } catch {
                                    logger.error("\(error.localizedDescription)")
                                }
                            }
                        }
                    })
                    .onEnded( { _ in
                        if keyCode == 99 {
                            let bit14: UInt16 = 0b0010_0000_0000_0000

                            logger.log("""
                                «««    DSKY 032:    \(zeroPadWord(bit14)) BITS (15)      \
                                :: \(keyText(keyCode)) ↑
                                """)
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ "PRO" key UP ..                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                            Task {
                                do {
                                    try await model.network.send(formIoPacket(0o032, bit14))
                                } catch {
                                    logger.error("\(error.localizedDescription)")
                                }
                            }
                        }
                    })
            )
    }
}

#if swift(>=5.9)
#Preview("Key [6]") { KeyView(keyCode: 6) }
#Preview("Key [∇]") { KeyView(keyCode: 255) }
#endif
