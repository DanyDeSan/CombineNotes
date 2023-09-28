//
//  LikeALaunchScreen.swift
//  Animations_Workshop vol2
//
//  Created by Talis on 27/09/23.
//

import SwiftUI

struct LikeALaunchScreen: View {
// isContentViewActive: Bool = false
    @State private var shouldDisplayContentView: Bool = false
    @State private var size = 1.5
    @State private var opacity = 0.8
    
    var body: some View {
        if shouldDisplayContentView {
            ContentView()
        } else {
            VStack {
                VStack {
                    Text("🛼")
                        .font(.system(size: 110.0))
                    Text("Arepa")
                        .font(.custom("MartianMono-Regular", size: 40.0))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        size = 0.9
                        opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        shouldDisplayContentView = true
                    }
                }
            }
        }
    }
}

#Preview {
    LikeALaunchScreen()
}
