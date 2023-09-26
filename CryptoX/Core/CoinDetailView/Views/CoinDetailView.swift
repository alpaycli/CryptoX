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
    @StateObject private var viewModel: CoinDetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .frame(width: 100, height: 100)
                
                Text("Overview")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
                    ForEach(viewModel.overviewStatistics) { stat in
                        StatisticItemView(statistic: stat)
                    }
                }
                
                Text("Additional")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
                    ForEach(viewModel.additionalStatistics) { stat in
                        StatisticItemView(statistic: stat)
                    }
                }
            }
            .padding(.leading)
        }
        .navigationTitle(viewModel.coin.name)
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: Coin.example)
        }
    }
}
