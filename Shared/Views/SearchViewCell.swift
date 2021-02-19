//
//  SearchViewCell.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 04.02.2021.
//

import Foundation
import SwiftUI

struct SearchViewCell: View {
    var itemName = "Bow (master)"
    var itemSellPrice = "Sell: 14379"
    var itemBuyPrice = "Buy: 5500"
    var profit = 32.3
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

            HStack {
                HStack(spacing: 5) {
                    Image("image")
                        .resizable()
                        .scaledToFit()
                    VStack(alignment: .leading) {
                        Text(itemName)
                        Text(itemSellPrice)
                        Text(itemBuyPrice)
                    }
                    .foregroundColor(.secondary)

                    Spacer()
                    
                    Text("Profit: " + String(format: "+%.1f", profit))
                    .foregroundColor(.secondary)

                }
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                Spacer()
            }

        }
        .frame(width: 350, height: 78, alignment: .center)
        .foregroundColor(.white)
    }
    
}
struct SearchViewCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewCell()
    }
}
