//
//  CoinImageService.swift
//  CryptoX
//
//  Created by Alpay Calalli on 09.09.23.
//

import Combine
import SwiftUI

final class CoinImageService: ObservableObject {
    @Published var image: UIImage?
    
    private var imageSubscription: AnyCancellable?
    
    init(coin: Coin) {
        getCoinImage(coin: coin)
    }
    
    private func getCoinImage(coin: Coin) {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(from: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
