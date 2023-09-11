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
        $searchText
            .combineLatest(service.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
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
    
}
