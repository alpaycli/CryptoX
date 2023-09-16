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
    private let portolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    // MARK: Public methods
    
    func updatePortolio(coin: Coin, amount: Double) {
        portolioDataService.updatePortolio(coin: coin, amount: amount)
    }
    
    // MARK: Private methods
    
    private func addSubscribers() {
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .map(filterMarketData)
            .sink { [weak self] returnedData in
                self?.statistics = returnedData
            }
            .store(in: &cancellables)
        
        // updates portolio coins
        $allCoins
            .combineLatest(portolioDataService.$portolioCoins)
            .map { (coins, portolioEntities) -> [Coin] in
                coins
                    .compactMap { coin -> Coin? in
                        guard let entity = portolioEntities.first(where: { $0.id == coin.id }) else { return nil }
                        return coin.updateHoldings(with: entity.amount)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
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
