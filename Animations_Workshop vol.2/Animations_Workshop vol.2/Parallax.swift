//
//  Parallax.swift
//  Animations_Workshop vol.2
//
//  Created by Talis on 27/09/23.
//

import SwiftUI

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    var title: String
    var color: Color
    
    static let preview: [ListItem] = [
        ListItem(title: "Yellow", color: .yellow),
        ListItem(title: "Orange", color: .orange),
        ListItem(title: "Blue", color: .blue),
        ListItem(title: "Green", color: .green),
        ListItem(title: "Purple", color: .purple),
        ListItem(title: "Red", color: .red)
    ]
}

struct Parallax: View {
    var body: some View {
        ScrollView {
            ForEach(ListItem.preview) { item in
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
                            .offset(x: offset(for: phase))
                    }
            }
        }
    }
    
    func offset(for phase: ScrollTransitionPhase) -> Double {
        switch phase {
        case .topLeading:
             -200
        case .identity:
            0
        case .bottomTrailing:
            200
        }
    }
}

#Preview {
    Parallax()
}
