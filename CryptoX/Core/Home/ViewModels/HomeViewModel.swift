//
//  HomeViewViewModel.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        fetchPortfolioCoins()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(filterMarketData)
            .sink { [weak self] returnedData in
                self?.statistics = returnedData
            }
            .store(in: &cancellables)
    }
    
    func fetchPortfolioCoins() {
        let coins = [Coin.example]
        
        portfolioCoins = coins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.contains(lowercasedText) ||
            coin.id.contains(lowercasedText) ||
            coin.symbol.contains(lowercasedText)
        }
    }
    
    private func filterMarketData(marketDataModel: MarketData?) -> [Statistic] {
        var stats: [Statistic] = []
        
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "Total Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistic(title: "Portolio", value: "0.00", percentageChange: 0.0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats

    }
}
