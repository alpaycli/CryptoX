//
//  CircleButtonView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct CircleButtonView: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .font(.headline)
            .foregroundColor(Color.theme.accentColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.backgroundColor)
            )
            .shadow(color: Color.theme.accentColor.opacity(0.25),
                    radius: 10)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(imageName: "info")
            .previewLayout(.sizeThatFits)
    }
}
