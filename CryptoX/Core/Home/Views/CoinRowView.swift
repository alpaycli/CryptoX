//
//  CoinRowView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldings: Bool
    
    var body: some View {
        HStack {
            leftColumn
            
            Spacer()
            
            if showHoldings {
                centerColumn
            }
            
            rightColumn
        }
        .background(Color.theme.backgroundColor.opacity(0.001))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: Coin.example, showHoldings: true)
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30)
            
            
            Text(coin.symbol.uppercased())
                .foregroundColor(Color.theme.accentColor)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 6)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .foregroundColor(Color.theme.accentColor)
                .fontWeight(.bold)
            
            Text("\(coin.currentHoldings ?? 0, specifier: "%.2f")")
                .foregroundColor(Color.theme.accentColor)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .foregroundColor(Color.theme.accentColor)
                .font(.headline)
                .fontWeight(.bold)
            
            Text("\(coin.priceChangePercentage24H ?? 0, specifier: "%.2f")%")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) > 0 ?
                    Color.theme.greenColor : Color.theme.redColor
                )
            
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
