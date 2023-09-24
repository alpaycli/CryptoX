//
//  CoinDetailView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 24.09.23.
//

import SwiftUI

struct CoinDetailLoadingView: View {
    @Binding var coin: Coin?
    init(coin: Binding<Coin?>) {
        self._coin = coin
    }
    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    let coin: Coin
    var body: some View {
        VStack {
            Text(coin.name)
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDetailView(coin: Coin.example)
    }
}
