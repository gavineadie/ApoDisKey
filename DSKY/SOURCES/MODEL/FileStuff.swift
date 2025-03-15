//
//  FileStuff.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Nov29/24 (copyright 2024-25)
//

import Foundation

/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ File stuff ..                                                                                    ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ File stuff ..                                                                                    ┆
  ┆ .. readCanned: reads DSKY channel i/o actions from a file and injects them into the DSKY ..      ┆
  ┆     blank lines or lines with less than three 'words' are ignored                                ┆
  ┆     "#" or "--" .. a comment (ignore)                                                            ┆
  ┆     "!" .. send remainer of the line to logger                                                   ┆
  ┆     "-end-of-file-" .. stop reading the file                                                     ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ Currect canned file format:                                                                      ┆
  ┆                                                                                                  ┆
  ┆     xxx xxx xxxxxxxxx     xxxxx                                                                  ┆
  ┆       |   |         |                                                                            ┆
  ┆       |   |         command (octal or binary with "_")                                           ┆
  ┆       |   channel to send command to (octal)                                                     ┆
  ┆       delay BEFORE action (milliSeconds)                                                         ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ Possible future, more readable, canned file format:                                              ┆
  ┆                                                                                                  ┆
  ┆     xxx xxx xxxxxxxxx     xxxxx                                                                  ┆
  ┆       |   |         |                                                                            ┆
  ┆       |   |         command (needs to be interpreted)                                            ┆
  ┆       |   channel to send command to (octal)                                                     ┆
  ┆       delay BEFORE action (seconds)                                                              ┆
  ┆                                                                                                  ┆
  ┆                     command                                                                      ┆
  ┆                         LAMPS (by name) : ON/OFF                                                 ┆
  ┆                         POWER and COMP : ON/OFF                                                  ┆
  ┆                         PROG, VERB, NOUN : <..>/OFF                                              ┆
  ┆                         REG1, REG2 and REG3 : <±.....>/OFF                                       ┆
  ┆                                                                                                  ┆
  ┆     0.5 011 COMP=ON         .15 010 PROG=64         .25 010 REG1=±88888                          ┆
  ┆     0.5 011 COMP=OFF        .15 010 PROG=.4         .25 010 REG2=77777                           ┆
  ┆                             .15 010 VERB=6.         .25 010 REG3=12...                           ┆
  ┆     1.0 010 GIMBAL=ON       .15 010 NOUN=OFF        .25 010 REG1=OFF                             ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func readCanned(url: URL) {
    logger.log("canned script: \"\(url.path)\"")
    do {
        var timerDeadline: TimeInterval = Date.now.timeIntervalSinceNow
        let initContent = try String(contentsOf: url, encoding: .utf8)
        let lineArray = initContent.components(separatedBy: .newlines)

        for line in lineArray {
            let words = line
                .components(separatedBy: .whitespaces)
                .filter({!$0.isEmpty})
            if #available(macOS 13.0, *) {
            	if words.isEmpty || words[0].starts(with: /#|--/) || words.count < 3 { continue }
            }
            if words[0].starts(with: "-end-of-file-") { return }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ each actionable line is set to take place at a future time ..                                    ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            let delaySecs = words[0].contains(".") ? Double(words[0]) ?? 0.0
                                                   : Double(Int(words[0]) ?? 0) / 1000.0
            timerDeadline += delaySecs

            Timer.scheduledTimer(withTimeInterval: timerDeadline, repeats: false) { _ in

                if words[0].starts(with: "!") {
                    logger.log("!!\(line)")
                } else {
//                  logger.log("---- \(words[1]) + \(words[2])")
                    if let channel = UInt16(words[1], radix: 8),
                       let command = words[2].count > 5
                                ? UInt16(words[2].filter { !($0 == "_") }, radix: 2)
                                : UInt16(words[2].filter { !($0 == "_") }, radix: 8) {
                        DispatchQueue.main.async {
                            channelAction(channel, command)
                        }
                    } else {
                        logger.log("'\(line)' -- bad format")
                    }
                }
            }
        }
    } catch {
        logger.error("\(error.localizedDescription)")
    }

}
