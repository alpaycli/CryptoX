//
//  CoinImageViewModel.swift
//  CryptoX
//
//  Created by Alpay Calalli on 09.09.23.
//

import Combine
import SwiftUI

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let service: CoinImageService
    
    private let coin: Coin
    init(coin: Coin) {
        self.coin = coin
        self.service = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscriber()
    }
    
    private func addSubscriber() {
        service.$image
            .sink { [weak self] resultImage in
                self?.isLoading = false
                self?.image = resultImage
            }
            .store(in: &cancellables)
    }
}
