//
//  Extensions.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul21/24.
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable colon
// swiftlint:disable comma
// swiftlint:disable switch_case_alignment
// swiftlint:disable vertical_whitespace
// swiftlint:disable file_length

import Foundation

let bit1:  UInt16 = 0b0000_0000_0000_0001
let bit2:  UInt16 = 0b0000_0000_0000_0010
let bit3:  UInt16 = 0b0000_0000_0000_0100
let bit4:  UInt16 = 0b0000_0000_0000_1000
let bit5:  UInt16 = 0b0000_0000_0001_0000
let bit6:  UInt16 = 0b0000_0000_0010_0000
let bit7:  UInt16 = 0b0000_0000_0100_0000
let bit8:  UInt16 = 0b0000_0000_1000_0000
let bit9:  UInt16 = 0b0000_0001_0000_0000
let bit10: UInt16 = 0b0000_0010_0000_0000

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆ The sign (or blank) characters, which can be "+" or "-" or " " is based of the 0/1 values of     ┆
  ┆ the "+" and "-" bits if the command sent to the DSKY.  The book says:                            ┆
  ┆                                                                                                  ┆
  ┆     .. bit 11 contains discrete information, a "1" (true) indicating that the discrete is on.    ┆
  ┆                                                                                                  ┆
  ┆     A one in bit 11 of DSPTAB+1 indicates that R3 has a plus sign.                               ┆
  ┆     If the sign bits associated with a given register are both zeros, then the content of        ┆
  ┆     that particular register is octal; if either of the bits is set, the register content is     ┆
  ┆     decimal data.                                                                                ┆
  ┆                                                                                                  ┆
  ┆ or:                                                                                              ┆
  ┆                                                                                                  ┆
  ┆     .. it is unclear to me how the +/- signs can be blanked, using the commands outlined below.  ┆
  ┆     It seems as though it would involve sending two output-channel commands, (say) with both     ┆
  ┆     1+ and 1- bits zeroed.                                                                       ┆
  ┆                                                                                                  ┆
  ┆     .. the most recent 1+ and 1- flags are saved. If both are 0, then the +/- sign is blank;     ┆
  ┆     if 1+ is set and 1- is not, then the '+' sign is displayed; if just the 1- flag is set,      ┆
  ┆     or if both 1+ and 1- flags are set, the '-' sign is displayed                                ┆
  ┆                                                                                                  ┆
  ┆                                                                                                  ┆
  ┆                                           +1    +0                                               ┆
  ┆                                         +-----+-----+                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                     -1  | "-" | "-" |                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                         +-----+-----+                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                     -0  | "+" | " " |                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                         +-----+-----+                                            ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

public func plu_min(_ pm: (Bool, Bool)) -> String {
    switch pm {
        case (false, false): return " "
        case (true, false): return "+"
        case (false, true): return "-"
        case (true, true): return "-"
    }
}


func prettyPrint(_ data: Data) {
    logger.log("\(zeroPadByte(data[0])) \(zeroPadByte(data[1])) \(zeroPadByte(data[2])) \(zeroPadByte(data[3]))")
}

func prettyString(_ data: Data) -> String {
    "\(zeroPadByte(data[0])) \(zeroPadByte(data[1])) \(zeroPadByte(data[2])) \(zeroPadByte(data[3]))"
}


private func zeroPadByte(_ code: UInt8, _ length: Int = 8) -> String {
    String(("000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func zeroPadWord(_ code: UInt16, to length: Int = 15) -> String {
    String(("0000000000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let symbolArray = ["----",
                   "3435", "3233", "2531", "2324", "2122",
                   "1415", "1213", "..11", "N1N2", "V1V2", "M1M2"]

let digitsDict = [  0: "_",
                    21: "0",  3: "1", 25: "2", 27: "3", 15: "4",
                    30: "5", 28: "6", 19: "7", 29: "8", 31: "9"]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆          Bit 1 lights the "PRIO DISP" indicator       -- ?                                       ┆
  ┆          Bit 2 lights the "NO DAP" indicator          -- ?                                       ┆
  ┆          Bit 3 lights the "VEL" indicator.                                                       ┆
  ┆          Bit 4 lights the "NO ATT" indicator          -- in left column                          ┆
  ┆          Bit 5 lights the "ALT" indicator.                                                       ┆
  ┆          Bit 6 lights the "GIMBAL LOCK" indicator.                                               ┆
  ┆          Bit 7                                        -- ?                                       ┆
  ┆          Bit 8 lights the "TRACKER" indicator.                                                   ┆
  ┆          Bit 9 lights the "PROG" indicator.                                                      ┆
  ┆                                                                                                  ┆
  ┆ Note:                     "TEMP" and                                                             ┆
  ┆                           "RESTART" are not controlled here                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch010Labs = [" ??? ",
                 "PROG ",    // b9
                 "TRAK ",    // b8
                 " b7? ",    // b7
                 "GMBL ",    // b6
                 " ALT ",    // b5
                 "~ATT ",    // b4
                 " VEL ",    // b3
                 "~DAP ",    // b2
                 "PRIO ",    // b1
                 "NEVER"]

@available(macOS 13.0, *)
func prettyCh010(_ code: UInt16) -> String {
	let bitArray = zeroPadWord(code, to: 10).split(separator: "")
	var catString = ""

	for index in 0..<bitArray.count {
		catString += (bitArray[index] == "0") ? "  ↓  " : ch010Labs[index]
	}

	return catString
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ All LATCHES                                                                                      ┆
  ┆                                                                                                  ┆
  ┆          Bit 1:                                                                                  ┆
  ┆          Bit 2: Lights the "COMP ACTY" indicator.                                                ┆
  ┆          Bit 3: Lights the "UPLINK ACTY" indicator.                                              ┆
  ┆          Bit 4: Lights the "TEMP" indicator.                                                     ┆
  ┆          Bit 5: Lights the "KEY REL" indicator.                                                  ┆
  ┆          Bit 6: Flashes the VERB/NOUN display areas.                                             ┆
  ┆                 This means to flash the digits in the NOUN and VERB areas.                       ┆
  ┆          Bit 7: Lights the "OPR ERR" indicator.                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch011Labs = [" ??? ",    // b8
                 "OPER ",    // b7
                 "V+N↕︎ ",    // b6
                 "KREL ",    // b5
                 "TEMP ",    // b4
                 "UPLK ",    // b3
                 "COMP ",    // b2
                 " ??? ",    // b1
                 "NEVER"]

@available(macOS 13.0, *)
func prettyCh011(_ code: UInt16) -> String {
    let bitArray = zeroPadWord(code, to: 8).split(separator: "")
    var catString = "          "

    for index in 0..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : ch011Labs[index]
    }

    return catString
}

@available(macOS 13.0, *)
func prettyCh032(_ code: UInt16) -> String {
    let bitArray = zeroPadWord(code).split(separator: "")
    var catString = ""

    for index in 0..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : "  ↑  "
    }

    return catString
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆          Bit 1:               AGC warning                                                        ┆
  ┆          _                                                                                       ┆
  ┆          _                                                                                       ┆
  ┆          Bit 4:            TEMP lamp                                                             ┆
  ┆          Bit 5:           KEY REL lamp                                                           ┆
  ┆          Bit 6:          VERB/NOUN flash                                                         ┆
  ┆          Bit 7:         OPER ERR lamp                                                            ┆
  ┆          Bit 8:        RESTART lamp                                                              ┆
  ┆          Bit 9:       STBY lamp                                                                  ┆
  ┆          Bit 10:     EL off                                                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch163Labs = [" EL↓ ",    // b10
                 "STBY ",    // b9
                 "RSRT ",    // b8
                 "OPER ",    // b7
                 "V+N↕︎ ",    // b6
                 "KREL ",    // b5
                 "TEMP ",    // b4
                 "  3  ",    // b3
                 "  2  ",    // b2
                 " AGC ",    // b1
                 "NEVER"]

@available(macOS 13.0, *)
func prettyCh163(_ code: UInt16) -> String {
    let bitArray = zeroPadWord(code, to: 10).split(separator: "")
    var catString = (bitArray[0] == "1") ? " EL↓ " : " EL↑ "

    for index in 1..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : ch163Labs[index]
    }

    return catString
}

#if os(macOS)
/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │  https://christiantietze.de/posts/2024/04/enable-swiftui-button-click-through-inactive-windows/  │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
import SwiftUI
extension SwiftUI.View {
    /// Enable the view to receive "first mouse" events.
    ///
    /// "First mouse" is the click into an inactive window that brings it to
    /// the front (activates it) and potentially triggers whatever control was
    /// clicked on. Controls that do support this are "click-through", because
    /// you can click on the inactive window, "through" its activation
    /// process, into the control.
    ///
    /// ## Using Buttons
    ///
    /// Wrap a button like this to make it respond to first clicks. The first
    /// mouse acceptance of this wrapper makes the button perform its action:
    ///
    /// ```swift
    /// Button { ... } label: { ... }
    ///     .style(.plain) // Style breaks default click-through
    ///     .acceptClickThrough() // Enables click-through again
    /// ```
    ///
    /// > Note: You need to stay somewhat close to the button. You can use
    ///         an `HStack`/`VStack` that wrap buttons, but not on a stack
    ///         that wraps custom views that contain the button 2+ levels deep.
    ///
    /// ## Using other tap gesture-enabled controls
    ///
    /// This also propagates "first mouse" tap gestures to interactive
    /// controls that are not buttons:
    ///
    /// ```swift
    /// VStack {
    ///     ForEach(...) { item in
    ///          CustomViewWithoutButtons(item)
    ///             .acceptClickThrough()
    ///             .onTapGesture { ... }
    ///     }
    /// }
    /// ```
    public func acceptClickThrough() -> some View {
        ClickThroughBackdrop(self)
    }
}

private struct ClickThroughBackdrop<Content: SwiftUI.View>: NSViewRepresentable {
    final class Backdrop: NSHostingView<Content> {
        override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
            return true
        }
    }

    let content: Content

    init(_ content: Content) {
        self.content = content
    }

    func makeNSView(context: Context) -> Backdrop {
        let backdrop = Backdrop(rootView: content)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        return backdrop
    }

    func updateNSView(_ nsView: Backdrop, context: Context) {
        nsView.rootView = content
    }
}
#endif

@MainActor
func extractOptions() {

    let args = CommandLine.arguments

    var ipAddr: String = ""
    var ipPort: UInt16 = 0

    let screenSize: CGSize = NSScreen.main!.frame.size
    var camArgsOffset = CGPoint(x: -999.0, y: -999.0)

    for var arg in args {
        if arg.hasPrefix("--cfg=") {
            arg.removeFirst(6)
            if arg.starts(with: "CM") {
                model.statusLights = DisKeyModel.CM
            } else if arg.starts(with: "LM1") {
                model.statusLights = DisKeyModel.LM1
            } else if arg.starts(with: "LM") {
                model.statusLights = DisKeyModel.LM0
            }

            model.elPowerOn = true
        } else if arg.hasPrefix("--ip=") {
            arg.removeFirst(5)
            ipAddr = arg
        } else if arg.hasPrefix("--port=") {
            arg.removeFirst(7)
            ipPort = UInt16(arg)!
        } else if arg.hasPrefix("--half-size") {
            model.fullSize = false
        } else if arg.hasPrefix("--x=") {
            arg.removeFirst(4)
            camArgsOffset.x = CGFloat(Float(Int(arg) ?? -999))
        } else if arg.hasPrefix("--y=") {
            arg.removeFirst(4)
            camArgsOffset.y = CGFloat(Float(Int(arg) ?? -999))
        } else if arg.hasPrefix("--log-timer") {
            model.logTimer = true
        }

        print("\(arg)")
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ if command arguments VirtualAGC app window position are good ..                                  ┆
  ┆                                                                                                  ┆
  ┆ The range of the command argument (x,y): (0,0) to (Sx-w,Sy-h) and must be mapped the range of    ┆
  ┆ the SwiftUI UnitPoint (-1,-1) to (+1,+1) ..                                                      ┆
  ┆                                                                                                  ┆
  ┆     Fx = 2x ÷ (Sx-w) - 1                                                                         ┆
  ┆     Fy = 2y ÷ (Sy-H) - 1                                                                         ┆
  ┆                                                                                                  ┆
  ┆             ┌─────────────────────────────────────────────────────────┐                          ┆
  ┆             │0,0                         |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |    (x,y)                   │                          ┆
  ┆             │                            |      ┌─────────────┐       │                          ┆
  ┆             │----------------------------+------│             │-------│                          ┆
  ┆             │                            |      │             │       │                          ┆
  ┆             │                            |      │             │       │                          ┆
  ┆             │                            |      │   569,656   │       │                          ┆
  ┆             │                            |      │             │       │                          ┆
  ┆             │                            |      │             │       │                          ┆
  ┆             │                            |      │             │       │                          ┆
  ┆             │                            |      └─────────────┘       │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             │                            |                            │                          ┆
  ┆             └─────────────────────────────────────────────────────────┘Sx,Sy                     ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

    if camArgsOffset.x >= 0.0 && camArgsOffset.y >= 0.0 {
        let screenAvailableWidth = CGFloat(screenSize.width - 569.0)
        let screenAvailableHeight = CGFloat(screenSize.height - 569.0)

        model.fX = min(camArgsOffset.x, screenAvailableWidth) / screenAvailableWidth
        model.fY = min(camArgsOffset.y, screenAvailableHeight) / screenAvailableHeight
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ if command arguments for network are good ..                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    if !ipAddr.isEmpty && ipPort > 0 {

        model.haveCmdArgs = true
        logger.log("""
            →→→ cmdArgs set: \
            ipAddr=\(ipAddr, privacy: .public), \
            ipPort=\(ipPort, privacy: .public)
            """)
        model.network = setNetwork(ipAddr, ipPort, start: true)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ start receiving packets from the AGC ..                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        Task {
            var keepGoing = true
            repeat {
                do {
                    if let rxPacket = try await model.network.connection
                        .rawReceive(length: 4) {
                        if let (channel, action, _) =
                            parseIoPacket(rxPacket) { channelAction(channel, action) }
                    }
                } catch {
                    print(error.localizedDescription)
                    keepGoing = false
                }
            } while keepGoing
        }

    }

}
