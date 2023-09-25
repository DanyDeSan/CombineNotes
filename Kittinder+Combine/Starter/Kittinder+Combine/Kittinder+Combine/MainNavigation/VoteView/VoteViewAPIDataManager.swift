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
        Empty().eraseToAnyPublisher()
    }
    
    func resetKey() -> AnyPublisher<Void,KeyChainManager.KeyChainError> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchCatImage(from url: String) -> AnyPublisher<UIImage?,VoteViewAPIDataManagerError>? {
        Empty().eraseToAnyPublisher()
    }
    
    func sendVote(_ voteType: VoteType, catID: String) -> AnyPublisher<Bool,VoteViewAPIDataManagerError> {
        Empty().eraseToAnyPublisher()
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
