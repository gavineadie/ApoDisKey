//
//  StatusView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/7/24.
//

import SwiftUI

struct PanelsView: View {
    var interiorFill: Color = panelInColor
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: panelExCorner)
                .fill(Color(panelExColor))
                .frame(width: panelExSizeW, height: panelExSizeH)

            RoundedRectangle(cornerRadius: panelInCorner)
                .fill(Color(interiorFill))
                .frame(width: panelExSizeW-panelInset,
                       height: panelExSizeH-panelInset)
        }
    }
}

#Preview {
    PanelsView(interiorFill: .pink)
}
