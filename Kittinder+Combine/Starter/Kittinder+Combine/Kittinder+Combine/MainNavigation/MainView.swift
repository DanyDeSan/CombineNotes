//
//  MainFlowView.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI

// MARK: - MainView
struct MainView: View {
    
    // MARK: observed objects
    @StateObject var coordinator: MainNavigationCoordinator
    
    // MARK: body
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.build()
        }
    }
}

struct MainFlowView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(coordinator: MainNavigationCoordinator(navigationPath: NavigationPath()))
    }
}
