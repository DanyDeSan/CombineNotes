//
//  VoteView.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 18/09/23.
//

import SwiftUI

// MARK: - VoteView
struct VoteView: View {
    
    // MARK: Observed attributes
    @ObservedObject var viewModel: VoteViewModel
    
    // MARK: body
    var body: some View {
        ZStack {
            VStack {
                Image("lunita_test", bundle: nil)
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
                            Text("American Wirehear")
                                .font(.callout)
                        }
                        HStack {
                            Text("Origin")
                                .font(.headline)
                            Spacer()
                            Text("Mexico")
                                .font(.callout)
                        }
                        HStack {
                            Text("Temperament")
                                .font(.headline)
                            Spacer()
                            Text("Sleepy")
                                .font(.callout)
                        }
                        HStack {
                            Text("Wikipedia Link")
                                .font(.headline)
                            Spacer()
                            Text("Link")
                                .font(.callout)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description")
                                .font(.title2)
                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dictum sed mauris non ullamcorper. Curabitur faucibus ex scelerisque arcu cursus, at auctor enim semper. Cras nisi quam, pretium vitae turpis id, lacinia tempus lectus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis vel lectus aliquet, malesuada ligula ac, pulvinar nulla. Quisque commodo, erat ut accumsan consequat, turpis tellus ultricies augue, vel aliquet turpis nunc at sapien. Mauris faucibus est non semper finibus. Vivamus placerat quis lacus sit amet pretium. Sed varius ex leo, vitae facilisis turpis tempor eu. Aenean luctus non sem ac euismod. Curabitur fermentum nibh non nulla mollis, ut suscipit neque convallis. ")
                                
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
