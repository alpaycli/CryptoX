//
//  StatisticsView.swift
//  CryptoX
//
//  Created by Alpay Calalli on 11.09.23.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var showingPortolio: Bool
    var body: some View {
        HStack {
            ForEach(viewModel.statistics) { stat in
                StatisticItemView(statistic: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showingPortolio ? .trailing : .leading)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(showingPortolio: .constant(false))
            .environmentObject(HomeViewModel())
    }
}
