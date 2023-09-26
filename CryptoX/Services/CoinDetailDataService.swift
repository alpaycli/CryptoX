//
//  CoinDetailDataService.swift
//  CryptoX
//
//  Created by Alpay Calalli on 25.09.23.
//

import Combine
import Foundation

final class CoinDetailDataService: ObservableObject {
    @Published var coinDetailData: CoinDetailModel? = nil
    private var coinDetailSubscription: AnyCancellable?

    init(coin: Coin) {
        fetchData(coinId: coin.id)
    }
    private func fetchData(coinId: String) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinId)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        coinDetailSubscription = NetworkManager.download(from: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedData in
                self?.coinDetailData = returnedData
                self?.coinDetailSubscription?.cancel()
            })
    }
}
