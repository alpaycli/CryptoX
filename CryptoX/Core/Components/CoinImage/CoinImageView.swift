//
//  CoinImageView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 09.09.23.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var viewModel: CoinImageViewModel
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else if viewModel.isLoading {
            ProgressView()
        } else {
            Circle()
                .fill(Color.theme.secondaryTextColor)
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: Coin.example)
    }
}
