//
//  AppCoordinator.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI
import Combine


// MARK: AppCoordinator
final class AppCoordinator {
    
    // MARK: Private attributes
    private let keyManager: KeyChainManager
    private var isUserRegister: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init(keyManager: KeyChainManager) {
        self.keyManager = keyManager
        bind()
    }
    
    func bind() {
        keyManager
            .fetchKey()
            .ignoreOutput()
            .sink { [weak self] completion in
                if completion == .finished {
                    self?.isUserRegister = true
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
    }
    
    @ViewBuilder
    func build() -> some View {
        if isUserRegister {
            buildMainModule()
        } else {
            buildAPIKeyInput()
        }
    }
    

    
    func buildMainModule() -> some View {
        let coordinator = MainNavigationCoordinator(navigationPath: NavigationPath())
        let mainView = MainView(coordinator: coordinator)
        return mainView
    }
    
    private func buildAPIKeyInput() -> some View {
        let viewModel = APIKeyInputViewModel(
            coordinator: self,
            keyChainManager: keyManager
        )
        let keyInputView = APIKeyInputView(viewModel: viewModel)
        
        return keyInputView
    }
}
