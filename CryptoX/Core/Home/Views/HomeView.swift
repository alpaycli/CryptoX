//
//  HomeView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 06.09.23.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                homeHeaderView
                
                StatisticsView(showingPortolio: $showPortfolio)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                columnTitles
                
                if showPortfolio {
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
            CircleButtonView(imageName: showPortfolio ? "plus" : "info")
                .animation(.none, value: 0)
                .background(
                    CircleButtonAnimationView(isAnimated: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accentColor)
                .animation(.none)
            Spacer()
            CircleButtonView(imageName: "arrow.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
            
        }
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            if showPortfolio {
                Text("Holdings")
            }
            
            Text("Price")
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
    }
    
    private var portolioCoinsList: some View {
        List(viewModel.portfolioCoins) { coin in
            CoinRowView(coin: coin, showHoldings: true)
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(.plain)
    }
    
}
