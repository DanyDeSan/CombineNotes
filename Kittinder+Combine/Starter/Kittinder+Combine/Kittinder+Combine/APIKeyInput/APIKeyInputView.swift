//
//  APIKeyInput.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 13/08/23.
//

import SwiftUI

// MARK: - APIKeyInputView
struct APIKeyInputView: View {
    // MARK: Observed attributes
    @ObservedObject var viewModel: APIKeyInputViewModel
    
    // MARK: Body
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
