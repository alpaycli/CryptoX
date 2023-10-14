//
//  HomeViewViewModel.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    
    @Published var searchText = ""
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var showPortfolio: Bool = false
    @Published var showEditPortolio: Bool = false
    
    @Published var sortOption: SortOption = .holdings
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
    
    // MARK: Private methods
    
    private func addSubscribers() {
        
        // updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                print("returning allCoins")
            }
            .store(in: &cancellables)
        
        // updates portolio coins
        $allCoins
            .combineLatest(portolioDataService.$portolioCoins)
            .map(mapAllCoinsToPortolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortolioCoinsIfNeeded(coins: returnedCoins)
                print("returning portfolioCoins")
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
    
    // MARK: Sort and Filter coins
    private func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &updatedCoins)
        
        return updatedCoins
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
    
    private func sortCoins(sortOption: SortOption, coins: inout [Coin]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    private func sortPortolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue } )
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue } )
        default:
            return coins
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
