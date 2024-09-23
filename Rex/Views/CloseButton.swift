//
//  CloseButton.swift
//  Rex
//
//  Created by Miclaine Emtman on 7/30/24.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label : {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color("AccentColor"))
        }
    }
}

#Preview {
    CloseButton(){}
}
