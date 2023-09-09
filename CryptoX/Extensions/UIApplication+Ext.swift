//
//  UIApplication+Ext.swift
//  CryptoX
//
//  Created by Alpay Calalli on 09.09.23.
//

import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
