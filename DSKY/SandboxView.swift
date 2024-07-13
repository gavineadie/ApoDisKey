//
//  SandboxView.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/8/24.
//

import SwiftUI

struct SandboxView: View {
    var body: some View {

        Text("+12121")
            .font(.custom("Zerlina", 
                          fixedSize: zerlinaFixedSize))
            .tracking(zerlinaTracking)
            .foregroundColor(displayElectro)
            .frame(width: 190.0,
                   height: 37.0)
    }
}

#Preview {
    SandboxView()
}

struct ButtonView: View {
    var body: some View {

        Text("Z\nX")
            .font(.custom("Gorton-Normal-120", size: 96))
            .foregroundColor(.red)
            .background(Color(.darkGray))
            .frame(width: 320, height: 320)
            .background(Color(.darkGray))
            .onTapGesture {
                print("tap")
            }
    }
}

#Preview {
    ButtonView()
}
