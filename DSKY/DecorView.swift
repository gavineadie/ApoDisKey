//
//  DecorView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/9/24.
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

struct DisplaySeparator: View {
    var body: some View {
        HStack {
            LittleWhiteCircle()

            Rectangle()
                .padding(.horizontal, -4.0)
                .frame(width: 144,
                       height: 4)
                .foregroundColor(.green)

            LittleWhiteCircle()
        }

    }
}

#Preview {
    DisplaySeparator()
}

struct LittleWhiteCircle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 4.0)
            .padding(0.0)
            .frame(width: 8.0, height: 8.0)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
