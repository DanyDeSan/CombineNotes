//
//  ContentView.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI

struct RootView: View {
    
    var coordinator: AppCoordinator
    
    var body: some View {
        coordinator.build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(coordinator: AppCoordinator(keyManager: KeyChainManager()))
    }
}
