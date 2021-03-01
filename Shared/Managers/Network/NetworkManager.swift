//
//  NetworkManager.swift
//  TestApi
//
//  Created by Yaroslav on 14.12.2020.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private(set) var session: URLSession
    private(set) var baseUrl: URL
    var errorSleepTime = 5
    var firstFailureRequest: URLRequest?
    private init() {
        self.session = URLSession.shared
        self.baseUrl = URL(string: "https://api.github.com/")!
    }
    
    func configure(with baseUrl: URL, session: URLSession = URLSession.shared) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    func makeRequest(_ request: ApiRequestProtocol,
                     success:@escaping (URLResponse?, Any?) -> Void, failure:@escaping (Error) -> Void) {
        guard firstFailureRequest == nil else { return }
        guard let urlRequest = self.prepareUrlRequest(with: request, failure: failure) else {
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                  let response = response else {
                if let error = error {
                    if let urlError = error as? URLError {
                        if Constants.noInternetErorrs.contains(urlError.code) || !Reachability.shared.isConnected {
                            self.firstFailureRequest = urlRequest
                            self.retryLastRequest(with: urlRequest, success: success, failure: failure)
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        failure(error)
                    }
                } else {
                    let nsError = NSError(domain: "Something went wrong", code: -999, userInfo: nil)
                    DispatchQueue.main.async {
                        failure(nsError)
                    }
                }
                return
            }
            success(response, data)
        }
        task.resume()
    }
    
    func makeRequest(_ request: ApiRequestProtocol) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        guard let urlRequest = self.prepareUrlRequest(with: request) else {
            return Result<(data: Data,
                           response: URLResponse), Error>
                .Publisher(NSError(domain: "Cant get url",
                                   code: -999,
                                   userInfo:nil))
                .eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { urlError -> Error in
                return NSError(domain: "Request failed with code: \(urlError.code)",
                               code: urlError.code.rawValue,
                               userInfo: nil)
            }.eraseToAnyPublisher()
    }
    

    private func prepareUrlRequest(with request: ApiRequestProtocol, failure: ((Error) -> Void)? = nil) -> URLRequest? {

        guard let endPoint = request.endPoint else {
            let error = NSError(domain: "Cant get endpoint", code: -999, userInfo: nil)
            failure?(error)
            return nil
        }
        guard let url = URL(string: endPoint, relativeTo: baseUrl) else {
            let error = NSError(domain: "Cant create url!", code: -999, userInfo: nil)
            failure?(error)
            return nil
        }
        var urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)

        if let queryParams = request.queryParam {
            urlComp?.queryItems = queryParams.compactMap { (key: String, value: Any) -> URLQueryItem? in
                return URLQueryItem(name: key, value: value as? String)
            }
        }
        guard let urlFromComp = urlComp?.url else {
            let error = NSError(domain: "Cant get url", code: -999, userInfo: nil)
            failure?(error)
            return nil
        }
        var urlRequest = URLRequest(url: urlFromComp)
        
        if var headers = request.headerParameters {
            if let contentType = request.contentType {
                headers["ContentType"] = contentType.toString()
            }
            headers.forEach { (key: String, value: Any) in
                urlRequest.setValue(value as? String, forHTTPHeaderField: key)
            }
        }

        urlRequest.httpBody = request.httpBody
        urlRequest.httpMethod = request.httpMethod.rawValue

        return urlRequest
    }

    private func retryLastRequest(with urlRequest: URLRequest,
                          success:@escaping (URLResponse?, Any?) -> Void, failure:@escaping (Error) -> Void) {
        Thread.sleep(forTimeInterval: TimeInterval(errorSleepTime))
        let task = session.dataTask(with: urlRequest) { data, response, error in
            print("Executed date:%@", Date())
            guard let data = data, let response = response else {
                if let error = error {
                    if let urlError = error as? URLError,
                       (Constants.noInternetErorrs.contains(urlError.code) ||
                            !Reachability.shared.isConnected) {
                        self.errorSleepTime *= 2
                        Reachability.shared.isConnected = false
                        self.retryLastRequest(with: urlRequest, success: success, failure: failure)
                        return
                    }

                    failure(error)
                } else {
                    let nsError = NSError(domain: "Something went wrong", code: -999, userInfo: nil)
                    failure(nsError)
                }
                return
            }
            Reachability.shared.isConnected = true
            self.firstFailureRequest = nil
            success(response, data)
        }
        task.resume()
    }
}
