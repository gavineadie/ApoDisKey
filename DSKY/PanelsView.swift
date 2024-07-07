//
//  StatusView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct PanelsView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color(.systemMint))
            .frame(width: panelSizeW, height: panelSizeH)
    }
}

#Preview {
    PanelsView()
}
