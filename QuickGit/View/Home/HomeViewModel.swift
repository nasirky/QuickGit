//
//  ProfileViewModel.swift
//  QuickGit
//
//  Created by Nasir on 16.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel: ViewModel<HomeViewModel.Input, HomeViewModel.State> {
    private unowned var parentViewModel: ViewModel<LoginViewModel.Input, LoginViewModel.State>

    private let gitHubService: GitHubService
    private var cancellables: Set<AnyCancellable> = .init()

    init(parentViewModel: ViewModel<LoginViewModel.Input, LoginViewModel.State>, gitHubService: GitHubService) {
        self.parentViewModel = parentViewModel
        self.gitHubService = gitHubService

        super.init(state: .init())
    }
    
    override func trigger(_ input: Input) {
        switch input {
        case .reloadProfile:
            gitHubService.fetchProfile()
                .ignoreFailure()
                .sink { [unowned self] profile in self.state.profile = profile }
                .store(in: &cancellables)
            
        case .reloadRepositories:
            gitHubService.fetchRepositories()
                .ignoreFailure()
                .sink { [unowned self] repositories in
                    self.state.repositoryViewModels = repositories.map {
                        RepositoryViewViewModel(repository: $0, gitHubService: self.gitHubService)
                    }
            }
                .store(in: &cancellables)
            case .logout:
                parentViewModel.trigger(.logout)
        }
    }
}

extension HomeViewModel {
    struct State {
        fileprivate(set) var profile: Profile? = nil
        fileprivate(set) var repositoryViewModels: [ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>] = []
    }
}

extension HomeViewModel {
    enum Input {
        case reloadProfile
        case reloadRepositories
//        case openRepository(Repository)
        case logout
    }
}
