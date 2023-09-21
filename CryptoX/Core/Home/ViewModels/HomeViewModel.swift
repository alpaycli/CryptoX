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
    
    @Published var showPortfolio: Bool = false
    @Published var showEditPortolio: Bool = false
    
    @Published var currentOption: SortOption?
    @Published var rankOption: SortOption = .rank
    @Published var holdingsOption: SortOption = .holdings
    @Published var priceOption: SortOption = .price
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
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
    
    func reloadData() {
        coinDataService.fetchAllCoins()
        marketDataService.fetchMarketData()
    }
    
    func sortData(option: SortOption) {
        
        switch option {
        case .rank:
            allCoins = allCoins.sorted(by: { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 } )
            currentOption = .rank
        case .rankReversed:
            allCoins = allCoins.sorted(by: { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0 } )
            currentOption = .rankReversed
        case .holdings:
            portfolioCoins = portfolioCoins.sorted(by:  { $0.currentHoldingsValue > $1.currentHoldingsValue } )
            currentOption = .holdings
        case .holdingsReversed:
            portfolioCoins = portfolioCoins.sorted(by:  { $0.currentHoldingsValue < $1.currentHoldingsValue } )
            currentOption = .holdingsReversed
        case .price:
            allCoins = allCoins.sorted(by:  { $0.currentPrice > $1.currentPrice } )
            currentOption = .price
        case .priceReversed:
            allCoins = allCoins.sorted(by:  { $0.currentPrice < $1.currentPrice } )
            currentOption = .priceReversed
        }
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
        
        // updates portolio coins
        $allCoins
            .combineLatest(portolioDataService.$portolioCoins)
            .map(mapAllCoinsToPortolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketData)
            .sink { [weak self] returnedData in
                self?.statistics = returnedData
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
    
    private func mapAllCoinsToPortolioCoins(allCoins: [Coin], portolioEntities: [PortolioEntity]) -> [Coin] {
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = portolioEntities.first(where: { $0.id == coin.id }) else { return nil }
                return coin.updateHoldings(with: entity.amount)
        }
    }
    
    private func mapMarketData(marketDataModel: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        
        guard let data = marketDataModel else { return stats }
        
        let portfolioValue = portfolioCoins
                                .map( { $0.currentHoldingsValue } )
                                .reduce(0, +)
        
        let previousValue = portfolioCoins
                                .map { coin -> Double in
                                    let currentValue = coin.currentHoldingsValue
                                    let priceChangePercentage = (coin.priceChangePercentage24H ?? 0) / 100
                                    let previousValue = currentValue / (priceChangePercentage + 1)
                                    
                                    return previousValue
                                }
                                .reduce(0, +)
        
//        let percentageChange = 100 - (previousValue * 100 / portfolioValue)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "Total Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = Statistic(title: "Portolio", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats

    }
}
