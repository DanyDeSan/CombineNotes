//
//  VoteViewAPIDataManager.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine
import UIKit

// MARK: - VoteViewAPIDataManager
final class VoteViewAPIDataManager {
    
    // MARK: VoteViewAPIDataManagerError
    enum VoteViewAPIDataManagerError: Error {
        case keyError
        case genericError
        case validationError
        case serverError
    }
    
    // MARK: VoteType
    enum VoteType: Int {
        case cute  = 1
        case notCute = -1
    }
    
    // MARK: Private Methods
    private let url = "api.thecatapi.com"
    private let urlSession = URLSession.shared
    private let keychainManager : KeyChainManager
    
    // MARK: Init
    init(keychainManager: KeyChainManager) {
        self.keychainManager = keychainManager
    }
    
    // MARK: Public Methods
    func fetchCatInfo() -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> {
        return keychainManager
            .fetchKey() // Publisher<String,KeyChaingError>
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap({ key -> URLRequest in  // Publisher<URLRequest,KeyChainError>
                guard let url = self.createFetchURL(withAPIKey: key) else { throw VoteViewAPIDataManagerError.genericError }
                return url
            })
            .mapError { keyChainError -> VoteViewAPIDataManagerError in  // Publisher<URLRequest,VoteAPIDataManagerError>
                return .keyError
            }
            .flatMap { request -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> in
                self.urlSession.dataTaskPublisher(for: request) // Publisher<(data: Data, response: URLResponse), URLError>
                    .map(\.data) // Publisher<Data,URLError>
                    .mapError({ error -> VoteViewAPIDataManagerError in  // Publisher<Data,VoteAPIDataManagerError>
                        switch error.errorCode {
                        case (400...500):
                            return .validationError
                        case (500...600):
                            return .serverError
                        default:
                            return VoteViewAPIDataManagerError.genericError
                        }
                    })
                    .decode(type: [CatInfoModel].self, decoder: JSONDecoder()) // Publisher<[CatInfoModel], Error>
                    .map({ dataResult -> CatInfoModel in // Publisher<CatInfoModel,Error>
                        return dataResult[0]
                    })
                    .mapError({ error -> VoteViewAPIDataManagerError in // Publisher<CatInfoModel, VoteAPIDataManagerError>
                        return VoteViewAPIDataManagerError.genericError
                    })
                    .eraseToAnyPublisher()  // AnyPublisher<CatInfoModel, VoteAPIDataManagerError>
            }
            .eraseToAnyPublisher() // AnyPublisher<CatInfoModel, VoteAPIDataManagerError>
    }
    
    func resetKey() -> AnyPublisher<Void,KeyChainManager.KeyChainError> {
        keychainManager.removeKey()
            .eraseToAnyPublisher()
    }
    
    func fetchCatImage(from url: String) -> AnyPublisher<UIImage?,VoteViewAPIDataManagerError>? {
        guard let url = URL(string: url) else { return nil }
        return urlSession.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
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
    
    func sendVote(_ voteType: VoteType, catID: String) -> AnyPublisher<Bool,VoteViewAPIDataManagerError> {
        return keychainManager
            .fetchKey()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap({ key -> URLRequest in
                guard let url = try? self.createVoteURL(
                    withAPIKey: key,
                    parameters: (catID: catID, vote: voteType)
                ) else {
                    throw VoteViewAPIDataManagerError.genericError
                }
                return url
            })
            .mapError { keyChainError -> VoteViewAPIDataManagerError in
                return .keyError
            }
            .flatMap { request -> AnyPublisher<Bool,VoteViewAPIDataManagerError> in
                self.urlSession.dataTaskPublisher(for: request)
                    .map({ _, response -> Bool in
                        guard let response = response as? HTTPURLResponse else { return false }
                        guard  response.statusCode == 200 || response.statusCode == 201 else {
                            return false
                        }
                        return true
                    })
                    .mapError({ error -> VoteViewAPIDataManagerError in
                        switch error.errorCode {
                        case (400...500):
                            return .validationError
                        case (500...600):
                            return .serverError
                        default:
                            return .genericError
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    // MARK: Private methods
    private func createFetchURL(withAPIKey key: String) -> URLRequest? {
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
        return urlRequest
    }
    
    private func createVoteURL(withAPIKey key: String, parameters: (catID: String, vote: VoteType)) throws -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = url
        urlComponents.path = "/v1/votes"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: key)
        ]
        urlComponents.queryItems = queryItems
        let voteModel = VoteModel(imageID: parameters.catID, subID: "110595", value: parameters.vote.rawValue)
        let jsonEncoder = JSONEncoder()
        let encodedVote = try jsonEncoder.encode(voteModel)
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = encodedVote
        return urlRequest
    }
    
}
