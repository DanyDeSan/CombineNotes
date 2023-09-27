//
//  Kittinder_CombineApp.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI

@main
struct Kittinder_CombineApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: AppCoordinator(keyManager: KeyChainManager()))
        }
    }
}
