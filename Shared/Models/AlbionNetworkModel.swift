//
//  File.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 02.02.2021.
//

import Foundation

class AlbionNetworkModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case localizationNameVariable = "LocalizationNameVariable"
        case localizationDescriptionVariable = "LocalizationDescriptionVariable"
        case localizedNames = "LocalizedNames"
        case localizedDescriptions = "LocalizedDescriptions"
        case index = "index"
        case uniqueName = "UniqueName"
    }
    
    var index: String?
    var localizationDescriptionVariable: String?
    var localizationNameVariable: String?
    var uniqueName: String?
    var localizedNames: [String:String]?
    var localizedDescriptions: [String:String]?
}
