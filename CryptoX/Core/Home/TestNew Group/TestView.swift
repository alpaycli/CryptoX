//
//  TestView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 19.09.23.
//

import SwiftUI

struct TestView: View {
    @State private var isTurned = false
    var body: some View {
        VStack {
            
            Image(systemName: isTurned ? "arrow.left.circle" : "arrow.right.circle")
                .font(.system(size: 60))
                .onTapGesture {
                    withAnimation {
                        buttonPressed()
                    }
                }
            
            Text("Salam!")
        }
    }
    func buttonPressed() {
        isTurned.toggle()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
