//
//  EditPortfolioView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 12.09.23.
//

import SwiftUI

struct EditPortfolioView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @State private var selectedCoin: Coin? = nil
    @State private var holdingAmount: String = ""
    
    @State private var showCheckmark = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                    coinsList

                    Spacer()
                    if selectedCoin != nil {
                        portolioInfoSection
                    }
                }
                .navigationTitle("Edit Portolio")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                if newValue.isEmpty { removeSelectedCoin() }
            }
        }
    }
    
    private func saveButtonAction() {
        
        guard let coin = selectedCoin,
            let amount = Double(holdingAmount)
        else { return }
        
        // save item to portolio
        viewModel.updatePortolio(coin: coin, amount: amount)
        
        withAnimation(.easeOut) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.dismissKeyboard()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
                dismiss()
            }
        }
    }
    
    private func removeSelectedCoin() {
        viewModel.searchText = ""
        holdingAmount = ""
        selectedCoin = nil
    }
    
    private func getCurrentValue() -> Double {
        if let amount = Double(holdingAmount) {
            return amount * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
}

struct EditPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        EditPortfolioView()
            .environmentObject(HomeViewModel())
    }
}

extension EditPortfolioView {
    private var coinsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoins : viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(coin.id == selectedCoin?.id ? Color.theme.greenColor : .clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        if let portolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let holdings = portolioCoin.currentHoldings {
            holdingAmount = "\(holdings)"
        } else { holdingAmount = "" }
    }
    
    
    private var portolioInfoSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $holdingAmount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none, value: 0.0)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
            
            Button("SAVE".uppercased()) {
                saveButtonAction()
            }
            .font(.headline)
        }
        .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(holdingAmount) ? 1 : 0)
    }
    
}
