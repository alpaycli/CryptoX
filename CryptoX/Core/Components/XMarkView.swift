//
//  XMarkView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 12.09.23.
//

import SwiftUI

struct XMarkView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            print("pressed")
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct XMarkView_Previews: PreviewProvider {
    static var previews: some View {
        XMarkView()
    }
}
