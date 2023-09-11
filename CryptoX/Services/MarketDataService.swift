//
//  MarketDataService.swift
//  CryptoX
//
//  Created by Alpay Calalli on 11.09.23.
//

import Combine
import Foundation

final class MarketDataService: ObservableObject {
    @Published var marketData: MarketData? = nil
    private var coinSubscription: AnyCancellable?
    
    init() {
        fetchMarketData()
    }
    
    private func fetchMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        coinSubscription = NetworkManager.download(from: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedData in
                self?.marketData = returnedData.data
                self?.coinSubscription?.cancel()
            })
    }
}
