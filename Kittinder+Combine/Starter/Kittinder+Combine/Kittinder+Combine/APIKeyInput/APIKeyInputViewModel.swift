//
//  APIKeyInputViewModel.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import Combine
import SwiftUI

// MARK: APIKeyInputViewModel
final class APIKeyInputViewModel: ObservableObject {
    
    // MARK: Published attributes
    @Published var shouldDisplayMainView: Bool = false
    
    // MARK: Public attributes
    var textFieldInput: String = ""
    
    // MARK: Private attributes
    private var coordinator: AppCoordinator?
    private let keyChainManager: KeyChainManager
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: Init
    init(coordinator: AppCoordinator?,
         keyChainManager: KeyChainManager) {
        self.coordinator = coordinator
        self.keyChainManager = keyChainManager
    }
    
    convenience init() {
        self.init(coordinator: nil, keyChainManager: KeyChainManager())
    }
    
    // MARK: Public methods
    func didTapOnSaveAPIKey() {

    }

    func obtainMainView() -> some View {
        coordinator?.buildMainModule()
    }
    
}
