//
//  VoteViewModel.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine
import SwiftUI

// MARK: VotViewModel
final class VoteViewModel: ObservableObject {
    
    typealias VoteType = VoteViewAPIDataManager.VoteType
    
    @Published var breedModel: BreedModel?
    @Published var catImage: Image = Image("lunita_test", bundle: nil)
    @Published var shouldShowError: Bool = false
    @Published var shouldShowVoteError: Bool = false
    private var apiDataManager: VoteViewAPIDataManager
    private var cancellables = Set<AnyCancellable>()
    private var currentImageCatReference: String?
    private var currentCatID: String?
    private var isSendingVote: Bool = false
    
    init(apiDataManager: VoteViewAPIDataManager) {
        self.apiDataManager = apiDataManager
    }
    
    func fetchData() {

    }
    
    func removeKey() {

        
    }
    
    func sendVote(isCute: Bool) {

    }
    
    // MARK: Private methods
    
    private func fetchCatImage(fromURL url: String) {

    }
}
