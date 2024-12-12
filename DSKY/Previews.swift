//
//  Previews.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on 11/28/24.
//

import SwiftUI

#Preview { StatusLight(light: ("WORDS", .off)) }
#Preview { StatusLight(light: ("WORDS", .orange)) }

#Preview { DisplayPlacard(label: "WORD") }

#Preview("ROW1") { Row1() }
#Preview("ROW2") { Row2() }
#Preview {
    VStack {
        Row1()
        Row2()
    }
}
