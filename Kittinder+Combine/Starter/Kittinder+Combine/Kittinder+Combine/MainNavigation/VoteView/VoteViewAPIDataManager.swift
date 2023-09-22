//
//  VoteViewAPIDataManager.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine

// MARK: - VoteViewAPIDataManager
final class VoteViewAPIDataManager {
    
    // MARK: - VoteViewAPIDataManagerError
    enum VoteViewAPIDataManagerError: Error {
        
        init(keyChainError: KeyChainManager.KeyChainError) {
            self = .keyError
        }
        
        case keyError
        case genericError
        case validationError
        case serverError
    }
    
    // MARK: Private attributers
    private let url = "api.thecatapi.com"
    private let urlSession = URLSession.shared
    private let keychainManager : KeyChainManager
    
    // MARK: init
    init(keychainManager: KeyChainManager) {
        self.keychainManager = keychainManager
    }
    
    // MARK: private methods
    private func createURLRequest(withAPIKey key: String) -> URL? {
        return nil
    }
    
    // MARK: public methods
    func fetchCatInfo() -> AnyPublisher<CatInfoModel,VoteViewAPIDataManagerError> {
        return Empty().eraseToAnyPublisher()
    }
}
