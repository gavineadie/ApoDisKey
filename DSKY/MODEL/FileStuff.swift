//
//  FileStuff.swift
//  DSKY
//
//  Created by Gavin Eadie on 10/29/24.
//

import Foundation

/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ File stuff ..                                                                                    ┃
  ┃──────────────────────────────────────────────────────────────────────────────────────────────────┃
  ┃ .. establishDirectory:                                                                           ┃
  ┃ .. readInitializing:                                                                             ┃
  ┃ .. readCanned:path:                                                                              ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/

func establishDirectory() -> URL { URL(fileURLWithPath: "~/ApoDisKey", isDirectory: true) }

func readInitializing() {
    if let path = Bundle.main.path(forResource: "Initialize", ofType: "txt"){
        do {
            let initContent = try String(contentsOfFile: path, encoding: .utf8)
            let lineArray = initContent.components(separatedBy: .newlines)
            for line in lineArray {
                logger.log("INIT: \(line)")
            }
        } catch {
            logger.log("\(error.localizedDescription)")
        }
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
            if words.isEmpty || words[0].starts(with: /#|--/) || words.count < 3 { continue }
            if words[0].starts(with: "-end-of-file-") { return }

            let delaySecs = Double(Int(words[0]) ?? 0) / 1000.0
            timerDeadline += delaySecs

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

            Timer.scheduledTimer(withTimeInterval: timerDeadline, repeats: false) { _ in

                if words[0].starts(with: "!") {
                    logger.log("!!\(line)")
                } else {
                    if let channel = UInt16(words[1], radix: 8),
                       let action = UInt16(words[2], radix: 8) {
                        channelAction(channel, action)
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
