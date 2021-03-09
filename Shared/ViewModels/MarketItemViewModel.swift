//
//  MarketItemViewModel.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 02.03.2021.
//

import CoreData

class MarketItemViewModel: ObservableObject {
    
    private let marketItem: MarketItem
    
    var cityName: String {
        get {
            marketItem.city ?? "Ooops can't get city"
        }
    }
    var sellPrice: String {
        get {
            String(marketItem.sellPriceMin)
        }
    }
    var buyPrice: String {
        get {
            String(marketItem.buyPriceMax)
        }
    }
    
    init(with item: MarketItem) {
        marketItem = item
    }
}
