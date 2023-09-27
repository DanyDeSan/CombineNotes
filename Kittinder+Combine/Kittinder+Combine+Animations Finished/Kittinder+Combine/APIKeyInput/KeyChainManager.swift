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
        return Future { [weak self] promise in
            guard let key = apiKey.data(using: .utf8),
                  let tag = self?.tag.data(using: .utf8) else {
                promise(.failure(.genericError))
                return
            }
            let attributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: tag,
                kSecValueData as String: key
            ]
            let status = SecItemAdd(attributes as CFDictionary, nil)
            guard status == errSecSuccess else {
                promise(.failure(.storeKeyError))
                return
            }
            promise(.success(Void()))
        }.eraseToAnyPublisher()
    }
    
    func fetchKey() -> AnyPublisher<String, KeyChainError> {
        return Future { [weak self] promise in

            guard let tag = self?.tag.data(using: .utf8) else {
                promise(.failure(.genericError))
                return
            }
            let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                           kSecAttrApplicationTag as String: tag,
                                           kSecMatchLimit as String: kSecMatchLimitOne,
                                           kSecReturnData as String: kCFBooleanTrue!,
                                           kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
            ]
            var item: AnyObject?
            let status = SecItemCopyMatching(getquery as CFDictionary, &item)
            guard status == errSecSuccess else {
                promise(.failure(.fetchKeyError))
                return
            }
            guard let data = item as? Data,
                  let key = String(data: data, encoding: .utf8)
            else {
                promise(.failure(.parseKeyError))
                return
            }
            promise(.success(key))
        }.eraseToAnyPublisher()
    }
    
    func removeKey() -> AnyPublisher<Void,KeyChainError> {
        return Future { [weak self] promise in
            guard let tag = self?.tag.data(using: .utf8) else {
                promise(.failure(.genericError))
                return
            }
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: tag
            ]
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                promise(.failure(.itemNotFoundError))
                return
            }
            promise(.success(Void()))
            
        }.eraseToAnyPublisher()
    }
    
    
}
