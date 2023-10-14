//
//  String+Ext.swift
//  CryptoX
//
//  Created by Alpay Calalli on 14.10.23.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
