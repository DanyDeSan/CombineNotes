//
//  VoteView.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import SwiftUI

struct VoteView: View {
    
    
    @ObservedObject var viewModel: VoteViewModel
    
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
                    }) )
                    .simultaneousGesture(LongPressGesture(minimumDuration: 4).onEnded({ _ in
                        viewModel.removeKey()
                    }))
                    .background(Color.green)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    Button(role: nil, action: {
                        
                    }, label: {
                        Text("Not Cute")
                            .frame(maxWidth: .infinity)
                            .padding()
                    })
                    .background(Color.red)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    
                }
            }
            .padding()
            .blur(radius: 0)
        }
        .onAppear(perform: {
            viewModel.fetchData()
        })
    }
}

struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(viewModel: VoteViewModel(apiDataManager: VoteViewAPIDataManager(keychainManager: KeyChainManager())))
    }
}
