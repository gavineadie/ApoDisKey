//
//  DisKeyBits.swift
//  ApoDisKey
//
//  DSKY Channel Bit Definitions
//

import Foundation

/// Bit field definitions for DSKY channels, organized by channel and function
struct DSKY {

    // MARK: - Basic Bit Values
    static let bit01: UInt16 = 0x0001
    static let bit02: UInt16 = 0x0002
    static let bit03: UInt16 = 0x0004
    static let bit04: UInt16 = 0x0008
    static let bit05: UInt16 = 0x0010
    static let bit06: UInt16 = 0x0020
    static let bit07: UInt16 = 0x0040
    static let bit08: UInt16 = 0x0080
    static let bit09: UInt16 = 0x0100
    static let bit10: UInt16 = 0x0200
    static let bit11: UInt16 = 0x0400
    static let bit12: UInt16 = 0x0800
    static let bit13: UInt16 = 0x1000
    static let bit14: UInt16 = 0x2000
    static let bit15: UInt16 = 0x4000

    // MARK: - Channel 010 Display Encoding
    struct Ch010_Display {
        static let rowCodeMask: UInt16 = 0b01111_0_00000_00000
        static let rowCodeShift = 11

        static let signBitMask: UInt16 = 0b00000_1_00000_00000
        static let signBitShift = 10

        static let leftDigitMask: UInt16 = 0b00000_0_11111_00000
        static let leftDigitShift = 5

        static let rightDigitMask: UInt16 = 0b00000_0_00000_11111
        static let rightDigitShift = 0

        // Row codes for different display elements
        enum RowCode: UInt16 {
            case r3Minus = 1                // "3435" & "R3-"
            case r3Plus = 2                 // "3233" & "R3+"
            case r2r3Digits = 3             // "2531"
            case r2Minus = 4                // "2324" & "R2-"
            case r2Plus = 5                 // "2122" & "R2+"
            case r1Minus = 6                // "1415" & "R1-"
            case r1Plus = 7                 // "1213" & "R1+"
            case r1Digit11 = 8              // "..11"
            case noun = 9                   // NOUN display
            case verb = 10                  // VERB display
            case program = 11               // PROG display

            case statusLights = 12          // Status annunciator lights
        }
    }

    // MARK: - Channel 010 Status Annunciators (when rowCode == 12)
    struct Ch010_Lights {
        static let priorityDisplay = bit01  // "PRIO DISP"
        static let noDAP = bit02            // "NO DAP"
        static let velocity = bit03         // "VEL"
        static let noAttitude = bit04       // "NO ATT"
        static let altitude = bit05         // "ALT"
        static let gimbalLock = bit06       // "GIMBAL LOCK"
                                            // bit7 unused
        static let tracker = bit08          // "TRACKER"
        static let program = bit09          // "PROG"
    }

    // MARK: - Channel 011 (Output flags for indicator lamps)
    struct Ch011 {
        static let compActivity = bit02     // "COMP ACTY" light
        static let uplinkActivity = bit03   // "UPLINK ACTY" light
        static let tempWarning = bit04      // "TEMP" light
        static let keyRelease = bit05       // "KEY REL" light
        static let verbNounFlash = bit06    // Flash VERB/NOUN displays
        static let operatorError = bit07    // "OPR ERR" light

        // Filter values for COMP ACTY cycling (don't log these)
        static let compActivityCycleValues: Set<UInt16> = [0x2000, 0x2002, 0x2200, 0x2202]
    }

    // MARK: - Channel 013 (DSKY lamp tests)
    struct Ch013 {
        static let standby = bit10          // "STBY" light
    }

    // MARK: - Channel 032 (Input)
    struct Ch032 {
        static let proKeyPressed = bit14    // PRO key state (inverted - UNSET means pressed)
    }

    // MARK: - Channel 163 (Hardware-corrected signals with flashing)
    struct Ch163 {
        static let agcWarning = bit01       // AGC warning
                                            // bits 2-3 unused
        static let tempLamp = bit04         // TEMP lamp (with flashing)
        static let keyRelLamp = bit05       // KEY REL lamp (with flashing)
        static let verbNounFlash = bit06    // VERB/NOUN flash control
        static let operErrLamp = bit07      // OPER ERR lamp (with flashing)
        static let restartLamp = bit08      // RESTART lamp
        static let standbyLamp = bit09      // STBY lamp
        static let elPowerOff = bit10       // EL panel power (inverted logic)
    }
}

// MARK: - Convenience Extensions
extension DSKY {

    /// Extract row code from channel 010₈ value
    static func extractRowCode(from value: UInt16) -> UInt16 {
        (value & Ch010_Display.rowCodeMask) >> Ch010_Display.rowCodeShift
    }

    /// Extract sign bit from channel 010 value
    static func extractSignBit(from value: UInt16) -> Bool {
        (value & Ch010_Display.signBitMask) > 0
    }

    /// Extract left digit from channel 010 value
    static func extractLeftDigit(from value: UInt16) -> UInt16 {
        (value & Ch010_Display.leftDigitMask) >> Ch010_Display.leftDigitShift
    }

    /// Extract right digit from channel 010 value
    static func extractRightDigit(from value: UInt16) -> UInt16 {
        (value & Ch010_Display.rightDigitMask) >> Ch010_Display.rightDigitShift
    }

    /// Check if a channel 011 value should be filtered from logging (COMP ACTY cycling)
    static func shouldLogCh011CompActy(value: UInt16) -> Bool {
        Ch011.compActivityCycleValues.contains(value)
    }
}
