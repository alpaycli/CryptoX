//
//  Statistic.swift
//  CryptoX
//
//  Created by Alpay Calalli on 11.09.23.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
    static let example = Statistic(title: "Market Cap", value: "12.099", percentageChange: -0.06)
}
