//
//  VoteViewAPIDataManager.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine

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
        return urlRequest.url
    }
    
//    func fetchCatInfo() -> AnyPublisher<CatInfoModel, VoteViewAPIDataManagerError> {
//        return keychainManager
//            .fetchKey()
//            .mapError({ _ in
//                return URLError(.init(rawValue: 1))
//            })
//            .flatMap { key -> URLSession.DataTaskPublisher in
//                let url = self.createURLRequest(withAPIKey: key)!
//                let publisher = self.urlSession.dataTaskPublisher(for: url)
//                return publisher
//            }
//            .map { data,_ in
//                return data
//            }
//            .decode(type: CatInfoModel.self, decoder: JSONDecoder())
//            .mapError { _ in
//                return VoteViewAPIDataManagerError.genericError
//                
//            }
//            .eraseToAnyPublisher()
//        
//    }
    
    func fetchCatInfo() -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> {
        return keychainManager
            .fetchKey()
            .tryMap({ key -> URL in
                guard let url = self.createURLRequest(withAPIKey: key) else { throw VoteViewAPIDataManagerError.genericError }
                return url
            })
            .mapError { keyChainError in
                return VoteViewAPIDataManagerError(keyChainError: keyChainError as? KeyChainManager.KeyChainError ?? .genericError)
            }
            .flatMap { url -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> in
                self.urlSession.dataTaskPublisher(for: url)
                    .map(\.data)
                    .mapError({ error in
                        return VoteViewAPIDataManagerError.genericError
                    })
                    .decode(type: CatInfoModel.self, decoder: JSONDecoder())
                    .mapError({ error in
                        return VoteViewAPIDataManagerError.genericError
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
