//
//  APIKeyInput.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI

struct APIKeyInputView: View {
    @ObservedObject var viewModel: APIKeyInputViewModel
    @State var input: String = ""
    var body: some View {
        VStack {
            Text("Kittinder")
                .font(.title)
                .fontWeight(.medium)
            Spacer()
            Text("To start type your API Key")
                .font(.body)
            TextField("API Key", text: $viewModel.textFieldInput)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            Button(role: nil, action: {
                viewModel.didTapOnSaveAPIKey()
            }, label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
            })
            .background(Color.blue)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
                
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.shouldDisplayMainView) {
            viewModel.obtainMainView()
        }
    }
}

struct APIKeyInput_Previews: PreviewProvider {
    static var previews: some View {
        APIKeyInputView(viewModel: APIKeyInputViewModel())
    }
}
