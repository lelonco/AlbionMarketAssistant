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
    @ObservedObject var sectionVM: SectionViewModel
    @State var didExpanded = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

            VStack {
                HStack {
                    HStack(spacing: 5) {
                        if let data = sectionVM.imageData {
                            Image(uiImage: (UIImage(data: sectionVM.imageData ?? Data()) ?? UIImage(named: "image"))!)
                                .resizable()
                                .scaledToFit()

                        } else {
                            ProgressView()
                                .frame(width: 78, height: 78, alignment: .center)
                        }
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
                if didExpanded {
                    List(sectionVM.prices) { item in
                        Text(item.city ?? "City")
                    }
                }
            }

        }
        .onTapGesture {
            didExpanded.toggle()
        }
        .frame(width: 350, height: 78, alignment: .center)
        .foregroundColor(.white)
        .onAppear(perform: { 
            self.sectionVM.prepareImage()
        })
    }
    
    init(with section: SectionViewModel) {
        self.sectionVM = section
    }
    
    
}
//struct SearchViewCell_Previews: PreviewProvider {
//    static var previews: some View {
////        SearchViewCell()
//    }
//}
