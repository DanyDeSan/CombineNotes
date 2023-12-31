//
//  VoteView.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import SwiftUI

struct VoteView: View {
    
    @ObservedObject var viewModel: VoteViewModel
    @State var lastVoteEmitted: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                viewModel.catImage
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/), style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                    .padding()
                ScrollView {
                    VStack(spacing: 5){
                        HStack {
                            Text("Breed Name")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.breedModel?.name ?? "")
                                .font(.callout)
                        }
                        HStack {
                            Text("Origin")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.breedModel?.origin ?? "")
                                .font(.callout)
                        }
                        HStack {
                            Text("Temperament")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.breedModel?.temperament ?? "")
                                .font(.callout)
                        }
                        HStack {
                            Text("Wikipedia Link")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.breedModel?.wikipediaURL ?? "")
                                .font(.callout)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.title2)
                            Text(viewModel.breedModel?.description ?? "")
                                
                        }.padding(.top, 5)
                    }
                }.padding()
                Spacer()
                HStack {
                    Button(role: nil, action: {
                    }, label: {
                        Text("Cute")
                            .frame(maxWidth: .infinity)
                            .padding()
                    })
                    .highPriorityGesture( TapGesture().onEnded({ _ in
                        print("Tap Gesture")
                        viewModel.sendVote(isCute: true)
                        lastVoteEmitted = true
                    }) )
                    .simultaneousGesture(LongPressGesture(minimumDuration: 4).onEnded({ _ in
                        viewModel.removeKey()
                    }))
                    .background(CuteButton())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .kerning(0.5)
                    Button(role: nil, action: {
                        viewModel.sendVote(isCute: false)
                        lastVoteEmitted = false
                    }, label: {
                        Text("Not Cute")
                            .frame(maxWidth: .infinity)
                            .padding()
                    })
                    .background(NotCuteButton())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    
                }
            }
            .padding()
            .blur(radius: 0)
            
            if viewModel.shouldShowLoader {
                LoadingView()
            }
        }
        .onAppear(perform: {
            viewModel.fetchData()
        })
        .alert("Something went wrong fetching the cat 😿", isPresented: $viewModel.shouldShowError) {
            Button("Try Again") {
                viewModel.fetchData()
            }
        }
        .alert("Your vote could not be sent 😿", isPresented: $viewModel.shouldShowVoteError) {
            Button("Try Again") {
                viewModel.sendVote(isCute: lastVoteEmitted)
            }
        }
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(viewModel: VoteViewModel(apiDataManager: VoteViewAPIDataManager(keychainManager: KeyChainManager())))
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                .scaleEffect(3.0) // CGsize
        }
    }
}

struct CuteButton : View {
    @State private var colorChange = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            colorChange ? .green : .blue,
            colorChange ? .yellow : .green
        ]), startPoint: .leading, endPoint: .trailing)
        .onReceive(timer) { time in
            withAnimation(.easeInOut) {
                self.colorChange.toggle()
            }}
    }
}

struct NotCuteButton : View {
    @State private var colorChange = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            colorChange ? .red : .orange,
            colorChange ? .yellow : .red
        ]), startPoint: .leading, endPoint: .trailing)
        .onReceive(timer) { time in
            withAnimation(.easeInOut) {
                self.colorChange.toggle()
            }}
    }
}
