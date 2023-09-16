//
//  CoinLogoView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 12.09.23.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
            
            
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: Coin.example)
    }
}
