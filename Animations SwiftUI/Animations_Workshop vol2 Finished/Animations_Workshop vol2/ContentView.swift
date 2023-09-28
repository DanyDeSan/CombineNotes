//
//  ContentView.swift
//  Animations_Workshop vol2
//
//  Created by Talis on 27/09/23.
//

import SwiftUI

struct ListItem: Identifiable {
    var id = UUID()
    var title: String
    var color: Color
}

let preview: [ListItem] = [
    ListItem(title: "Yellow", color: .yellow),
    ListItem(title: "Pink", color: .pink),
    ListItem(title: "Green", color: .green),
    ListItem(title: "Purple", color: .purple),
    ListItem(title: "Blue", color: .blue),
    ListItem(title: "Orange", color: .orange),
    ListItem(title: "Red", color: .red)
]

struct ContentView: View {
    var body: some View {
        ScrollView {
            // GeometryReader
            ForEach(preview) { item in
                item.color
                    .frame(height: 200.0)
                    .overlay {
                        Text(item.title)
                    }
                    .cornerRadius(20.0)
                    .padding(.horizontal)
                    .scrollTransition { effect, phase in
                    effect
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            .blur(radius: phase.isIdentity ? 0 : 20)
                            .offset(x: offset(for: phase))
                    }
            }
        }
    }
    
    func offset(for phase: ScrollTransitionPhase) -> Double {
        switch phase {
        case .topLeading:
            -100
        case .identity:
            0
        case .bottomTrailing:
            100
        }
    }
    
}

#Preview {
    ContentView()
}
