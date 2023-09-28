//
//  CustomLoader.swift
//  MoreAnimations!
//
//  Created by L Daniel De San Pedro on 27/09/23.
//

import SwiftUI

struct CustomLoader: View {
    
    @State private var isLoading = false
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(.green, lineWidth: 5)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                //.animation(.default.repeatForever(autoreverses: false), value: isLoading)
                .animation(.linear(duration: 0.5).repeatForever(autoreverses: false), value: isLoading)
                .onAppear() {
                    self.isLoading = true
            }
            .padding()
            
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(.green, lineWidth: 7)
                    .frame(width: 100, height: 100)
                    .rotationEffect(Angle(degrees: isLoading ? 360 : 0 ))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
            }
            .padding()
            
            ZStack {
                Text("Loading")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .offset(x: 0, y: -25)
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(.systemGray5), lineWidth: 3)
                    .frame(width: 250, height: 3)
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.green, lineWidth: 3)
                    .frame(width: 30, height: 3)
                    .offset(x: isLoading ? 110 : -110, y: 0)
                    .animation(.linear(duration: 1).repeatForever(autoreverses: true), value: isLoading)
            }
            .padding()
            
            ZStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(.title, design: .rounded))
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.green, lineWidth: 10)
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
            }
            .padding()
            .onAppear() {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    self.progress += 0.05
                    if self.progress >= 1.0 {
                        self.progress = 0
                    }
                }
            }
            
            HStack {
                ForEach(0...4, id: \.self) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                        .scaleEffect(self.isLoading ? 0 : 1)
                        .animation(
                            .linear(duration: 0.6)
                            .repeatForever()
                            .delay(0.2 * Double(index)), value: isLoading)
                }
            }
            .padding()
        }
    }
}



#Preview {
    CustomLoader()
}
