//
//  Items.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import Foundation
import CoreData

struct Items {
    static let shared = Items()
    var itemsDic: [String]
    
    private init() {
        itemsDic = [String]()
        if let path = Bundle.main.path(forResource: "albionItems", ofType: "") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let string = String(data: data, encoding: .utf8)!
                let splited = string.split(separator: "\n")
                itemsDic = splited.reduce(into: itemsDic) { (res, substr) in
                    let splitedStr = substr.split(separator: ":")
                    res.append(splitedStr.last!.lowercased())
                }
                print(itemsDic.count)
            } catch {
                print(error.localizedDescription)
            }

        }
    }
}
