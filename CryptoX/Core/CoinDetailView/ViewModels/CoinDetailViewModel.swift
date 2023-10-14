//
//  CoinDetailViewModel.swift
//  CryptoX
//
//  Created by Alpay Calalli on 25.09.23.
//

import Combine
import Foundation

final class CoinDetailViewModel: ObservableObject {
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    
    @Published var coinDescription: String? = nil
    @Published var coinSubredditURL: String? = nil
    @Published var coinHomepageURL: String? = nil
        
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coin: Coin
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailDataService.$coinDetailData
            .combineLatest($coin)
            .map(mapToStatistics)
            .sink { [weak self] returnedData in
                self?.overviewStatistics = returnedData.overview
                self?.additionalStatistics = returnedData.additional
                print("returning coinDetailData")
            }
            .store(in: &cancellables)
        
        
        coinDetailDataService.$coinDetailData
            .sink { [weak self] returnedData in
                guard let self else { return }
                self.coinDescription = returnedData?.description?.en
                self.coinSubredditURL = returnedData?.links?.subredditURL
                self.coinHomepageURL = returnedData?.links?.homepage?.first
            }
            .store(in: &cancellables)
    }
    
    private func mapToStatistics(coinDetailModel: CoinDetailModel?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        let overviewStats = createOverviewStats(coinDetailModel: coinDetailModel, coin: coin)
        let additionalStats = createAdditionalStats(coinDetailModel: coinDetailModel, coin: coin)
        
        return (overviewStats, additionalStats)
    }
    
    
    private func createOverviewStats(coinDetailModel: CoinDetailModel?, coin: Coin) -> [Statistic] {
        var overviewStats: [Statistic] = []
        
        let currentPrice = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H ?? 0.0
        let currentPriceStat = Statistic(title: "Current Price", value: currentPrice, percentageChange: pricePercentChange)
        
        let marketCapValue = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let priceChangePercentValue = coin.priceChangePercentage24H ?? 0.0
        let marketCapStat = Statistic(title: "Market Cap Capitalization", value: marketCapValue, percentageChange: priceChangePercentValue)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        overviewStats.append(contentsOf: [
            currentPriceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ])
        
        return overviewStats
    }
    
    private func createAdditionalStats(coinDetailModel: CoinDetailModel?, coin: Coin) -> [Statistic] {
        var overviewStats: [Statistic] = []
        
        let highValue = coin.high24H?.asCurrencyWith6Decimals() ?? ""
        let highStat = Statistic(title: "24h High", value: highValue)
        
        let lowValue = coin.low24H?.asCurrencyWith6Decimals() ?? ""
        let lowStat = Statistic(title: "24h Low", value: lowValue)
        
        let priceChangeValue = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let priceChangePercentValue2 = coin.priceChangePercentage24H ?? 0.0
        let priceChangeStat = Statistic(title: "Price Change", value: priceChangeValue, percentageChange: priceChangePercentValue2)
        
        let marketCapChangeValue = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChangeValue = coin.marketCapChangePercentage24H ?? 0.0
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChangeValue, percentageChange: marketCapPercentChangeValue)
        
        overviewStats.append(contentsOf: [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat
        ])
        
        return overviewStats
    }
}
