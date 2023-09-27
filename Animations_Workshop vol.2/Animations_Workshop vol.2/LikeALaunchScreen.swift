//
//  LikeALaunchScreen.swift
//  Animations_Workshop vol.2
//
//  Created by Talis on 27/09/23.
//
import SwiftUI

struct LikeALaunchScreen: View {
    @State private var isActive = false
    @State private var size = 1.5
    @State private var opacity = 0.8
    
    var body: some View {
        if isActive {
            Parallax()
        } else {
            VStack {
                VStack {
                    Text("🛼")
                        .font(.system(size: 110.0))
                    Text("Arepa")
                        .font(.system(size: 40.0))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    LikeALaunchScreen()
}
