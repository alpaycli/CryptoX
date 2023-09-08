//
//  HomeViewViewModel.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    private let service = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("salam")
        fetchAllCoins()
        fetchPortfolioCoins()
    }
    
    func fetchAllCoins() {
        service.$allCoins
            .sink { [weak self] resultCoins in
                self?.allCoins = resultCoins
            }
            .store(in: &cancellables)
    }
    
    func fetchPortfolioCoins() {
        let coins = [Coin.example]
        
        portfolioCoins = coins
    }
}
