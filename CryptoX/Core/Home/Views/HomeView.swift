//
//  HomeView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
                .sheet(isPresented: $viewModel.showEditPortolio) {
                    EditPortfolioView()
                        .environmentObject(viewModel)
                }
            
            VStack {
                homeHeaderView
                
                StatisticsView(showingPortolio: $viewModel.showPortfolio)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if viewModel.showPortfolio {
                    portolioCoinsList
                        .transition(.move(edge: .trailing))
                } else {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(HomeViewModel())
                .navigationBarHidden(true)
        }
    }
}

extension HomeView {
    private var homeHeaderView: some View {
        HStack {
            CircleButtonView(imageName: viewModel.showPortfolio ? "plus" : "info")
                .animation(.none, value: 0)
                .background(
                    CircleButtonAnimationView(isAnimated: $viewModel.showPortfolio)
                )
                .onTapGesture {
                    if viewModel.showPortfolio { viewModel.showEditPortolio = true }
                }
            
            Spacer()
            Text(viewModel.showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accentColor)
                .animation(.none)
            Spacer()
            CircleButtonView(imageName: "arrow.right")
                .rotationEffect(Angle(degrees: viewModel.showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.showPortfolio.toggle()
                    }
                }
            
        }
    }
    
    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")
                
                if viewModel.currentOption == .rank || viewModel.currentOption == .rankReversed {
                    Image(systemName: "chevron.up")
                        .rotationEffect(Angle(degrees: viewModel.rankOption == .rank ? 0 : 180))
                }
            }
            .onTapGesture {
                withAnimation {
                    if viewModel.rankOption == .rank {
                        viewModel.sortData(option: .rankReversed)
                        viewModel.rankOption = .rankReversed
                    } else {
                        viewModel.sortData(option: .rank)
                        viewModel.rankOption = .rank
                    }
                }
            }
            
            Spacer()
            
            if viewModel.showPortfolio {
                HStack {
                    Text("Holdings")
                    
                    if viewModel.currentOption == .holdings || viewModel.currentOption == .holdingsReversed {
                        Image(systemName: "chevron.up")
                            .rotationEffect(Angle(degrees: viewModel.holdingsOption == .holdings ? 0 : 180))
                    }
                }
                .onTapGesture {
                    withAnimation {
                        if viewModel.holdingsOption == .holdings {
                            viewModel.sortData(option: .holdingsReversed)
                            viewModel.holdingsOption = .holdingsReversed
                        } else {
                            viewModel.sortData(option: .holdings)
                            viewModel.holdingsOption = .holdings
                        }
                    }
                }
            }
            
            HStack {
                Text("Prices")
                
                if viewModel.currentOption == .price || viewModel.currentOption == .priceReversed {
                    Image(systemName: "chevron.up")
                        .rotationEffect(Angle(degrees: viewModel.priceOption == .price ? 0 : 180))
                }
            }
            .onTapGesture {
                withAnimation {
                    if viewModel.priceOption == .price {
                        viewModel.sortData(option: .priceReversed)
                        viewModel.priceOption = .priceReversed
                    } else {
                        viewModel.sortData(option: .price)
                        viewModel.priceOption = .price
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            
        }
        .foregroundColor(Color.theme.secondaryTextColor)
        .font(.caption)
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List(viewModel.allCoins) { coin in
            CoinRowView(coin: coin, showHoldings: false)
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }
    
    private var portolioCoinsList: some View {
        List(viewModel.portfolioCoins) { coin in
            CoinRowView(coin: coin, showHoldings: true)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(.plain)
    }
    
    // MARK: Sorting methods
    
//    private func sortByRank() {
//        switch rankOption {
//        case .none:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.marketCapRank ?? 0 < second.marketCapRank ?? 0
//            }
//            rankOption = .ascending
//        case .ascending:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.marketCapRank ?? 0 > second.marketCapRank ?? 0
//            }
//            rankOption = .descending
//        case .descending:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.marketCapRank ?? 0 < second.marketCapRank ?? 0
//            }
//            rankOption = .none
//        }
//    }
//
//    private func sortByPrices() {
//        switch priceOption {
//        case .none:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.currentPrice > second.currentPrice
//            }
//            priceOption = .ascending
//        case .ascending:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.currentPrice < second.currentPrice
//            }
//            priceOption = .descending
//        case .descending:
//            viewModel.allCoins = viewModel.allCoins.sorted { first, second in
//                first.marketCapRank ?? 0 < second.marketCapRank ?? 0
//            }
//            priceOption = .none
//        }
//    }
//
//    private func sortByHoldings() {
//        switch holdingsOption {
//        case .none:
//            viewModel.portfolioCoins = viewModel.portfolioCoins.sorted { first, second in
//                first.currentHoldingsValue > second.currentHoldingsValue
//            }
//            holdingsOption = .ascending
//        case .ascending:
//            viewModel.portfolioCoins = viewModel.portfolioCoins.sorted { first, second in
//                first.currentHoldingsValue < second.currentHoldingsValue
//            }
//            holdingsOption = .descending
//        case .descending:
//            viewModel.portfolioCoins = viewModel.portfolioCoins.sorted { first, second in
//                first.marketCapRank ?? 0 < second.marketCapRank ?? 0
//            }
//            holdingsOption = .none
//        }
//
//    }
}
