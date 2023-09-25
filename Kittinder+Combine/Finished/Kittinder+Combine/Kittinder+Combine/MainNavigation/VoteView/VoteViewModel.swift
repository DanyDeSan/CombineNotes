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
        apiDataManager.fetchCatInfo()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    guard let currentImageCatReference = self.currentImageCatReference else { return }
                    self.fetchCatImage(fromURL: currentImageCatReference)
                case .failure(let _):
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
            .sink { completion in
                switch completion {
                case .finished:
                    print("Reseted Key :)")
                case .failure(_):
                    print("Something failed while trying to reset Key")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

    }
    
    func sendVote(isCute: Bool) {
        guard !isSendingVote,
        let currentCatID = currentCatID else { return }
        var voteType = isCute ? VoteType.cute : VoteType.notCute
        apiDataManager.sendVote(voteType, catID: currentCatID)
            .sink { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    print("finished")
                    self.fetchData()
                case .failure(let error):
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
            .sink { completion in
                switch completion {
                case .finished:
                    debugPrint("Succesfully fetched image")
                case .failure(let error):
                    debugPrint("Failed to obtain image", error)
                }
            } receiveValue: { [weak self] image in
                guard let image = image else { return }
                self?.catImage = Image(uiImage: image)
            }.store(in: &cancellables)
    }
}
