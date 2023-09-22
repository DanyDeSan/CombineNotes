//
//  VoteViewModel.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine

// MARK: VotViewModel
final class VoteViewModel: ObservableObject {
    
    @Published var catInfoModel: CatInfoModel?
    private var apiDataManager: VoteViewAPIDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(apiDataManager: VoteViewAPIDataManager) {
        self.apiDataManager = apiDataManager
    }
    
    func fetchData() {
        apiDataManager.fetchCatInfo()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { value in
                print(value)
            }.store(in: &cancellables)
    }
    
}
