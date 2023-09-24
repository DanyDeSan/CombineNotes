//
//  VoteViewAPIDataManager.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine
import UIKit

final class VoteViewAPIDataManager {
    
    enum VoteViewAPIDataManagerError: Error {
        
        init(keyChainError: KeyChainManager.KeyChainError) {
            self = .keyError
        }
        
        
        case keyError
        case genericError
        case validationError
        case serverError
    }
    
    private let url = "api.thecatapi.com"
    private let urlSession = URLSession.shared
    private let keychainManager : KeyChainManager
    
    
    init(keychainManager: KeyChainManager) {
        self.keychainManager = keychainManager
    }
    
    private func createURLRequest(withAPIKey key: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = url
        urlComponents.path = "/v1/images/search"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "has_breeds", value: "1"),
            URLQueryItem(name: "api_key", value: key)
        ]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return  nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        debugPrint(urlRequest.url)
        return urlRequest.url
    }
    

    
    func fetchCatInfo() -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> {
        return keychainManager
            .fetchKey()
            .tryMap({ key -> URL in
                debugPrint(key)
                guard let url = self.createURLRequest(withAPIKey: key) else { throw VoteViewAPIDataManagerError.genericError }
                return url
            })
            .mapError { keyChainError in
                debugPrint(keyChainError)
                return VoteViewAPIDataManagerError(keyChainError: keyChainError as? KeyChainManager.KeyChainError ?? .genericError)
            }
            .flatMap { url -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> in
                self.urlSession.dataTaskPublisher(for: url)
                    .map(\.data)
                    .mapError({ error in
                        debugPrint(error)
                        return VoteViewAPIDataManagerError.genericError
                    })
                    .decode(type: [CatInfoModel].self, decoder: JSONDecoder())
                    .map({ dataResult in
                        return dataResult[0]
                    })
                    .mapError({ error in
                        debugPrint(error)
                        return VoteViewAPIDataManagerError.genericError
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func resetKey() -> AnyPublisher<Void,KeyChainManager.KeyChainError> {
        keychainManager.removeKey()
            .eraseToAnyPublisher()
    }
    
    func fetchCatImage(from url: String) -> AnyPublisher<UIImage?,VoteViewAPIDataManagerError>? {
        guard let url = URL(string: url) else { return nil }
        return urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .map { response -> UIImage? in
                return UIImage(data: response.data)
            }
            .mapError { error -> VoteViewAPIDataManagerError in
                switch error.errorCode {
                case (400...500):
                    return .validationError
                case (500...600):
                    return .serverError
                default:
                    return .genericError
                }
            }.eraseToAnyPublisher()
            
    }
}
