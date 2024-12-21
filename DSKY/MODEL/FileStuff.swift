//
//  FileStuff.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 10/29/24.
//

import Foundation

/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ File stuff ..                                                                                    ┃
  ┃──────────────────────────────────────────────────────────────────────────────────────────────────┃
  ┃ .. readInitializing:                                                                             ┃
  ┃ .. readCanned:path:                                                                              ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/

func readInitializing() {
    if let initURL = Bundle.main.url(forResource: "Initialize", withExtension: "txt"){
        do {
            let initContent = try String(contentsOf: initURL, encoding: .utf8)
//            let lineArray = initContent.components(separatedBy: .newlines)
//            for line in lineArray {
//                logger.log("INIT: \(line)")
//            }
        } catch {
            logger.log("\(error.localizedDescription)")
        }
    } else {
        logger.log("••• \(#function): \"Initialize.txt\" not found in Bundle.")
    }
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ File stuff ..                                                                                    ┆
  ┆ .. readCanned: reads DSKY channel i/o actions from a file and injects them into the DSKY ..      ┆
  ┆     "#" .. a comment (ignore)                                                                    ┆
  ┆     "--" .. a comment (ignore)                                                                   ┆
  ┆     "!" .. send remainer of the line to logger                                                   ┆
  ┆     "-end-of-file-" .. stop reading the file                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func readCanned(path: String) {
    logger.log("canned script: \(path)")
    do {
        var timerDeadline: TimeInterval = Date.now.timeIntervalSinceNow
        let initContent = try String(contentsOfFile: path, encoding: .utf8)
        let lineArray = initContent.components(separatedBy: .newlines)

        for line in lineArray {
            let words = line
                .components(separatedBy: .whitespaces)
                .filter({!$0.isEmpty})
            if #available(macOS 13.0, *) {
            	if words.isEmpty || words[0].starts(with: /#|--/) || words.count < 3 { continue }
            }
            if words[0].starts(with: "-end-of-file-") { return }

            let delaySecs = Double(Int(words[0]) ?? 0) / 1000.0
            timerDeadline += delaySecs

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

            Timer.scheduledTimer(withTimeInterval: timerDeadline, repeats: false) { _ in

                if words[0].starts(with: "!") {
                    logger.log("!!\(line)")
                } else {
                    logger.log("---- \(words[1]) + \(words[2])")
                    if let channel = UInt16(words[1], radix: 8),
                       let command = words[2].count > 5 ?
                                    UInt16(words[2].filter{ !($0 == "_") }, radix: 2) :
                                    UInt16(words[2].filter{ !($0 == "_") }, radix: 8) {
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
        print(error)
    }

}
