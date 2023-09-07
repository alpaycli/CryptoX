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
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error", error)
                }
            } receiveValue: { [weak self] allCoins in
                self?.allCoins = allCoins
                self?.coinSubscription?.cancel()
            }


    }
}
