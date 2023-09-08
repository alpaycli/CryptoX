//
//  CoinDataService.swift
//  CryptoX
//
//  Created by Alpay Calalli on 07.09.23.
//

import Combine
import Foundation

final class CoinDataService: ObservableObject {
    @Published var allCoins: [Coin] = []
    private var coinSubscription: AnyCancellable?
    
    init() {
        fetchAllCoins()
    }
    
    private func fetchAllCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkManager.download(from: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
