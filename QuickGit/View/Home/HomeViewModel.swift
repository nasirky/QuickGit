//
//  ProfileViewModel.swift
//  QuickGit
//
//  Created by Nasir on 16.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel: ViewModel<HomeViewModel.Input, Profile?> {
    private unowned var store: AppStore

    private let gitHubService: GitHubService
    private var cancellables: Set<AnyCancellable> = .init()

    init(store: AppStore, gitHubService: GitHubService) {
        self.store = store
        self.gitHubService = gitHubService

        super.init(state: nil)
    }
    
    override func trigger(_ input: Input) {
        switch input {
        case .reloadProfile:
            gitHubService.fetchProfile()
                .ignoreFailure()
                .sink { profile in
                    self.state = profile
                }
                .store(in: &cancellables)
        case .logout:
            store.send(.logout)
        }
    }
}

extension HomeViewModel {
    enum Input {
        case reloadProfile
        case logout
    }
}
