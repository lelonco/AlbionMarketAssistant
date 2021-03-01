//
//  ApiRequest.swift
//  TestApi
//
//  Created by Yaroslav on 14.12.2020.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum ContentType {
    case json
    case xml
    case octetStream
    case custom(string: String)
    
    func toString() -> String {
        switch self {

        case .json:
            return "application/json"
        case .xml:
            return "application/xml"
        case .octetStream:
            return "application/octet-stream"
        case .custom(string: let string):
            return string
        }
    }
}

protocol ApiRequestProtocol {
    var httpMethod: HttpMethod { get }
    var endPoint: String? { get }
    var headerParameters: [String: Any]? { get }
    var queryParam: [String: Any]? { get }
    var httpBody: Data? { get }
    var contentType: ContentType? { get }
    var customURLString: String? { get }
}
