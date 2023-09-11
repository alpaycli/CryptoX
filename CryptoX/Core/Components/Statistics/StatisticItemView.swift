//
//  StatisticItemView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 11.09.23.
//

import SwiftUI

struct StatisticItemView: View {
    let statistic: Statistic
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .foregroundColor(Color.theme.secondaryTextColor)
                .font(.caption)
            
            Text("\(statistic.value)")
                .foregroundColor(Color.theme.accentColor)
                .font(.headline)
            
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle.degrees((statistic.percentageChange ?? 0) > 0 ? 0 : 180))
                Text("\((statistic.percentageChange ?? 0), specifier: "%.2f")%")
                    .font(.caption)
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.theme.greenColor : Color.theme.redColor)
            .opacity(statistic.percentageChange == nil ? 0 : 1)
            
        }
    }
}

struct StatisticItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticItemView(statistic: Statistic.example)
    }
}
