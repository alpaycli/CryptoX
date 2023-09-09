//
//  CircleButtonAnimationView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var isAnimated: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(isAnimated ? 1.0 : 0.0)
            .opacity(isAnimated ? 0.0 : 1.0)
            .animation(isAnimated ? Animation.easeOut : .none, value: isAnimated ? 1.0 : 0)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(isAnimated: .constant(false))
    }
}
