//
//  VoteViewModel.swift
//  Kittinder+Combine
//
//  Created by L Daniel De San Pedro on 21/09/23.
//

import Foundation
import Combine

// MARK: - VoteViewModel
final class VoteViewModel: ObservableObject {
    
    // MARK: published attributes
    @Published var catInfoModel: CatInfoModel?
    
    // MARK: private attributes
    private var apiDataManager: VoteViewAPIDataManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init
    init(apiDataManager: VoteViewAPIDataManager) {
        self.apiDataManager = apiDataManager
    }
    
    // MARK: public methods
    func fetchData() {

    }
    
}
