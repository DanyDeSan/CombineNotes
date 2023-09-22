//
//  MainNavigationCoordinator.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import Combine
import SwiftUI

final class MainNavigationCoordinator: ObservableObject {
    
    @Published var navigationPath: NavigationPath
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationPath: NavigationPath) {
        self.navigationPath = navigationPath
    }
    
    @ViewBuilder
    func build() -> some View {
        buildVoteView()
    }
    
    private func buildVoteView() -> some View {
        let viewModel = VoteViewModel(apiDataManager: VoteViewAPIDataManager(keychainManager: KeyChainManager()))
        return VoteView(viewModel: viewModel)
    }
    
    
}
