//
//  StatusModel.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/11/24.
//

import Foundation

struct StatusModel {
    var lightsState: [Bool]

    mutating func set(_ index: Int, _ state: Bool) {
        lightsState[index] = state
    }

}

