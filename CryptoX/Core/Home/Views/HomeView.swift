//
//  HomeView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView = false
    
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
        .background(
            NavigationLink(destination: CoinDetailLoadingView(coin: $selectedCoin),
                           isActive: $showDetailView,
                           label: { EmptyView() })
        )
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
                
                Image(systemName: "chevron.down")
                    .opacity( (viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1 : 0 )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rankReversed ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    if viewModel.sortOption == .rank {
                        viewModel.sortOption = .rankReversed
                    } else {
                        viewModel.sortOption = .rank
                    }
                }
            }
            
            Spacer()
            
            if viewModel.showPortfolio {
                HStack {
                    Text("Holdings")
                    
                    Image(systemName: "chevron.down")
                        .opacity( (viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1 : 0 )
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdingsReversed ? 180 : 0))
                }
                .onTapGesture {
                    withAnimation {
                        if viewModel.sortOption == .holdings {
                            viewModel.sortOption = .holdingsReversed
                        } else {
                            viewModel.sortOption = .holdings
                        }
                    }
                }
            }
            
            HStack {
                Text("Prices")
                
                Image(systemName: "chevron.down")
                    .opacity( (viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1 : 0 )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .priceReversed ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    if viewModel.sortOption == .price {
                        viewModel.sortOption = .priceReversed
                    } else {
                        viewModel.sortOption = .price
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
                .onTapGesture { seque(coin: coin) }
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
                .onTapGesture { seque(coin: coin) }
        }
        .listStyle(.plain)
    }
}

extension HomeView {
    private func seque(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}
