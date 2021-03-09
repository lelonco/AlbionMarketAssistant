//
//  ImageManager.swift
//  AlbionAssistant (iOS)
//
//  Created by Yaroslav Ark on 05.03.2021.
//

import Foundation
import UIKit
import Combine

final class ImageManager {
    private lazy var networkManager = NetworkManager.shared
    
    static let shared: ImageManager = ImageManager()
    
    private init() {
        
    }
    
    func imageData(for item: AlbionItem) -> Future<UIImage, Error> {
        return Future { [weak self] promise in
            guard let self = self,
                  let itemName = item.uniqueName else {
                return promise(.failure(NSError(domain: "Cant get item name = \(item.uniqueName)",
                                                code: -999,
                                                userInfo:nil)))
            }
            if let storredData = self.loadData(with: itemName),
               let unwrappedImage = UIImage(data: storredData) {
                return promise(.success(unwrappedImage))
            }
            let req = AlbionApi.getImageFor(item: itemName, quality: 0)
            self.networkManager.downloadRequest(req) { [weak self](response, data) in
                guard let imageData = data as? Data,
                      let recievedImage = UIImage(data: imageData) else {
                    //TODO: Add retry request
                    return promise(.failure(NSError(domain: "Cant get image, image data count = \((data as? Data)?.count) \n \(itemName)",
                                                    code: -999,
                                                    userInfo:nil)))
                }
                self?.save(data: imageData, fileName: itemName)
                promise(.success(recievedImage))
            } failure: { (error) in
                promise(.failure(error))
            }
        }
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
    
    private func loadData(with fileName: String) -> Data? {
        do {
            var path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileNameWithExtension = fileName.appending(".jpg")
            path.appendPathComponent(fileNameWithExtension)
            
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            return data
        } catch {
            print("cant find \(fileName)")
            return nil
        }
    }
}
