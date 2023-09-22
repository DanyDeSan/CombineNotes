//
//  MainNavigationCoordinator.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import Combine
import SwiftUI

// MARK: - MainNavigationCoordinator
final class MainNavigationCoordinator: ObservableObject {
    
    // MARK: published attributes
    @Published var navigationPath: NavigationPath
    
    // MARK: private attributes
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init
    init(navigationPath: NavigationPath) {
        self.navigationPath = navigationPath
    }
    
    // MARK: public methods
    @ViewBuilder
    func build() -> some View {
        buildVoteView()
    }
    
    // MARK: private methods
    private func buildVoteView() -> some View {
        let viewModel = VoteViewModel(apiDataManager: VoteViewAPIDataManager(keychainManager: KeyChainManager()))
        return VoteView(viewModel: viewModel)
    }
    
    
}
