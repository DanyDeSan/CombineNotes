//
//  KeyChainManager.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Security
import Combine
import Foundation

// MARK: - KeyChainManager
final class KeyChainManager {
    
    // MARK: KeyChainError
    enum KeyChainError: Error {
        case storeKeyError
        case itemNotFoundError
        case genericError
        case fetchKeyError
        case parseKeyError
    }
    
    // MARK: private attributes
    private let tag = "com.kodemia.kittinder"
   
    // MARK: public methods
    func storeKey(_ apiKey: String) -> AnyPublisher<Void,KeyChainError> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchKey() -> AnyPublisher<String, KeyChainError> {
        Empty().eraseToAnyPublisher()
    }
    
    func removeKey() -> AnyPublisher<Void,KeyChainError> {
        Empty().eraseToAnyPublisher()
    }
    
    
}
