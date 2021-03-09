//
//  RequestBuilder.swift
//  TestApi
//
//  Created by Yaroslav on 14.12.2020.
//

import Foundation

enum AlbionApi: ApiRequestProtocol {
    
    case searchRepo(text: String, perPage: Int)
    case getImageFor(item:String, quality: Int)
    var httpMethod: HttpMethod {
        return .get
    }
    
    var endPoint: String? {
        switch self {
        case .searchRepo:
            return  "search/repositories"
        case .getImageFor(item: let itemName):
            return "v1/item/\(itemName.item)"
        default:
            return nil
        }
    }
    
    var headerParameters: [String : Any]? {
        return [:]
    }
    
    var queryParam: [String : Any]? {
        
        switch self {
        case .searchRepo(let text, let perPage):
            return ["q": text, "sort": "stars", "order": "desc", "per_page": "\(perPage)"]
        case .getImageFor(item: _, quality: let quality):
            return ["quality":"\(quality)"]
        default:
            return nil
        }
    }
    
    var httpBody: Data? {
        nil
    }
    
    var contentType: ContentType? {
        .json
    }
    
    var customURLString: String? {
        switch self {
        case .getImageFor:
            return "https://render.albiononline.com"
        default:
            return nil
        }
    }

}


//class RequestBuilder {
//
//    static func searchRepo(text: String) -> ApiRequest {
//        let gitApi = ApiRequest(endPoint: "search/repositories")
//        let perPage = 50
//        let queryparam = ["q": text, "sort": "stars", "order": "desc", "per_page": "\(perPage)"]
//        gitApi.queryParam = queryparam
//        return gitApi
//    }
//}
