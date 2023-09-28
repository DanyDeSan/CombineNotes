//
//  ContentView.swift
//  MoreAnimations!
//
//  Created by L Daniel De San Pedro on 27/09/23.
//

import SwiftUI

struct HearView: View {
    
    @State private var circleColorChanged = false
    @State private var heartColorChanged = false
    @State private var heartSizeChanged = false
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 200, height: 200) .foregroundColor(circleColorChanged ? Color(.systemGray5) : .red)
                .animation(.default, value: circleColorChanged)
            
            Image(systemName: "heart.fill")
                .foregroundColor(heartColorChanged ? .red : .white)
                .font(.system(size: 100))
                .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                .animation(.default, value: heartSizeChanged)
        }
        .onTapGesture {
            self.circleColorChanged.toggle()
            self.heartColorChanged.toggle()
            self.heartSizeChanged.toggle()
        }
    }
}

#Preview {
    HearView()
}
