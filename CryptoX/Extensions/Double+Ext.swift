//
//  Double+Ext.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import Foundation

extension Double {
    
    /// Converrts a double into a Currency with 2-6 decimals places.
    /// ```
    /// Converts 1234.56  to $1,234.56
    /// Converts 12.3456  to $12.3456
    /// Converts 0.123456 to $0.123456
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
//        formatter.locale = .current       <- default value
//        formatter.currencyCode = "usd"    <- change currency
//        formatter.currencySymbol = "$"    <- change symbol
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converrts a double into a Currency as String with 2-6 decimals places.
    /// ```
    /// Converts 1234.56  to $1,234.56
    /// Converts 12.3456  to $12.3456
    /// Converts 0.123456 to $0.123456
    ///```
    func asCurrencWithDecimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
}
