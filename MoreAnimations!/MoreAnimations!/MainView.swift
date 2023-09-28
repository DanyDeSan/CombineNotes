//
//  MainView.swift
//  MoreAnimations!
//
//  Created by L Daniel De San Pedro on 27/09/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView(content: {
            List {
                NavigationLink("State Button") {
                    HearView()
                }
                NavigationLink("Custom Loaders") {
                    CustomLoader()
                }
                NavigationLink("Morphing Button") {
                    MorphingButton()
                }
            }
        })
        
    }
}

#Preview {
    MainView()
}
