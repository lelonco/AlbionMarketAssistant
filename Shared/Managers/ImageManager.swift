//
//  ImageManager.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 05.03.2021.
//

import Foundation
import UIKit

final class ImageManager {
    private lazy var networkManager = NetworkManager.shared
    
    static let shared: ImageManager = ImageManager()
    
    private init() {
        
    }
    
    func imageData(for item:AlbionItem) -> UIImage? {
        guard let itemName = item.uniqueName else { return nil }
        if let storredData = loadData(with: itemName) {
            return UIImage(data: storredData)
        }
        let req = AlbionApi.getImageFor(item: itemName, quality: 0)
        var image: UIImage? = nil
        networkManager.downloadRequest(req) { (response, data) in
            guard let imageData = data as? Data,
                  let recievedImage = UIImage(data: imageData) else { return }
            image = recievedImage
        } failure: { (error) in
            assertionFailure(error.localizedDescription)
        }

        return image
    }
    
    func imageData(for marketItem:MarketItem) -> UIImage? {
        
        switch marketItem.city {
        case "Bridgewatch":
            return UIImage(named: "bridgewatchCrest")
        case "Caerleon":
            //TODO: - Add crest for Caerleon
            break
        case "Fort Sterling":
            return UIImage(named: "fortSterlingCrest")
        case "Lymhurst":
            return UIImage(named: "lymhurstCrest")
        case "Martlock":
            return UIImage(named: "martlockCrest")
        case "Thetford" :
            return UIImage(named: "thetfordCrest")
        case "Black Market":
            //TODO: - Add crest for Marke
            break
        default:
            break
        }
        return nil
    }
    
    private func save(data: Data, fileName: String) -> Bool {
        do {
            var path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileNameWithExtension = fileName.appending(".jpg")
            path.appendPathComponent(fileNameWithExtension)
            try data.write(to: path)
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
        return true
    }
    
    private func loadData(with filename: String) -> Data? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "jpg") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}
