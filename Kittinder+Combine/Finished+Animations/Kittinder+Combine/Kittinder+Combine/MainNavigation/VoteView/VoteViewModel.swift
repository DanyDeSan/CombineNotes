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
    @Published var shouldShowLoader: Bool = false
    private var apiDataManager: VoteViewAPIDataManager
    private var cancellables = Set<AnyCancellable>()
    private var currentImageCatReference: String?
    private var currentCatID: String?
    private var isSendingVote: Bool = false
    
    init(apiDataManager: VoteViewAPIDataManager) {
        self.apiDataManager = apiDataManager
    }
    
    func fetchData() {
        shouldShowLoader = true
        apiDataManager.fetchCatInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    guard let currentImageCatReference = self.currentImageCatReference else { return }
                    self.fetchCatImage(fromURL: currentImageCatReference)
                case .failure:
                    shouldShowLoader = false
                    self.shouldShowError = true
                }
            } receiveValue: { [weak self] value in
                guard let breed = value.breeds?.first else { return }
                self?.breedModel = breed
                self?.currentImageCatReference = value.url
                self?.currentCatID = value.id
            }.store(in: &cancellables)
    }
    
    func removeKey() {
        debugPrint("Attempting to reset the key")
        apiDataManager.resetKey()
            .ignoreOutput()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Reseted Key :)")
                case .failure(_):
                    // isloader = false
                    print("Something failed while trying to reset Key")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
    }
    
    func sendVote(isCute: Bool) {
        shouldShowLoader = true
        guard !isSendingVote,
              let currentCatID = currentCatID else { return }
        let voteType = isCute ? VoteType.cute : VoteType.notCute
        apiDataManager.sendVote(voteType, catID: currentCatID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    print("finished")
                    self.fetchData()
                case .failure:
                    shouldShowLoader = false
                    self.shouldShowVoteError = true
                }
            } receiveValue: { wasSent in
                print(wasSent)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private methods
    
    private func fetchCatImage(fromURL url: String) {
        guard let publisher = apiDataManager.fetchCatImage(from: url) else { return }
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.shouldShowLoader = false
                switch completion {
                case .finished:
                    debugPrint("Succesfully fetched image")
                case .failure:
                    self?.catImage = Image("lunita_test", bundle: nil)
                }
            } receiveValue: { [weak self] image in
                guard let image = image else { return }
                self?.catImage = Image(uiImage: image)
            }.store(in: &cancellables)
    }
}
