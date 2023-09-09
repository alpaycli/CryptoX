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
    
    private let fileManager = LocalFileManager.shared
    private let imageName: String
    private let folderName = "coin_images"
    
    init(coin: Coin) {
        imageName = coin.id
        getCoinImage(coin: coin)
    }
    
    private func getCoinImage(coin: Coin) {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage(coin: coin)
        }
    }
    
    private func downloadCoinImage(coin: Coin) {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkManager.download(from: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedImage in
                guard let self else { return }
                guard let downloadedImage = returnedImage else { return }
                
                self.image = returnedImage
                self.imageSubscription?.cancel()
                
                fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            })
    }
}
