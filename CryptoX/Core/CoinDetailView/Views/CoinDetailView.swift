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
    
    @State private var expendDescriptionText = false
    
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
            VStack {
                ChartView(coin: viewModel.coin)
                
                VStack(spacing: 20) {
                    overviewText
                    Divider()
                    descriptionSection
                    
                    overviewStatGrid
                    
                    additionalText
                    Divider()
                    additionalStatGrid
                    
                    websitesSection
                }
                .padding(.leading)
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(viewModel.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryTextColor)
                    
                    CoinImageView(coin: viewModel.coin)
                        .frame(width: 25)
                }
            }
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: Coin.example)
        }
    }
}

extension CoinDetailView {
    // MARK: Overview stat extensions
    private var overviewText: some View {
        Text("Overview")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                VStack (alignment: .leading){
                    Text(coinDescription.removingHTMLOccurances)
                        .lineLimit(expendDescriptionText ? .max : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryTextColor)
                    
                    Button(expendDescriptionText ? "Less" : "Read more...") {
                        withAnimation(.easeInOut) {
                            expendDescriptionText.toggle()
                        }
                    }
                    .font(.caption)
                    .padding(.vertical, 4)
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overviewStatGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(viewModel.overviewStatistics) { stat in
                StatisticItemView(statistic: stat)
            }
        }
    }
    
    // MARK: Additional stat extensions
    private var additionalText: some View {
        Text("Additional")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.theme.accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalStatGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(viewModel.additionalStatistics) { stat in
                StatisticItemView(statistic: stat)
            }
        }
    }
    
    private var websitesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let homepageURL = viewModel.coinHomepageURL, !homepageURL.isEmpty,
               let url = URL(string: homepageURL) {
                Link(destination: url) {
                    Text("Website")
                }
            }
            
            if let redditURL = viewModel.coinSubredditURL, !redditURL.isEmpty,
               let url = URL(string: redditURL) {
                Link(destination: url) {
                    Text("Reddit")
                }
            }
        }
        .foregroundColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
