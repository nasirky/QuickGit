//
//  RepositoryViewViewModel.swift
//  QuickGit
//
//  Created by Nasir on 16.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

class RepositoryViewViewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State> {
    private let gitHubService: GitHubService
    private var cancellables: Set<AnyCancellable> = .init()

    init(repository: Repository, gitHubService: GitHubService) {
        self.gitHubService = gitHubService

        super.init(state: .init(repository: repository))
    }

    override func trigger(_ input: Input) {
        switch(input) {
        case .reloadIssues:
            gitHubService.fetchIssues(for: state.repository)
                .ignoreFailure()
                .sink { issues in self.state.issues = issues }
                .store(in: &cancellables)
        case .reloadContributors:
            gitHubService.fetchContributors(for: state.repository)
                .ignoreFailure()
                .sink { contributors in self.state.contributors = contributors }
                .store(in: &cancellables)
        case .reloadPullRequests:
            gitHubService.fetchPullRequest(for: state.repository)
                .ignoreFailure()
                .sink { pullRequests in self.state.pullRequests = pullRequests }
                .store(in: &cancellables)
        case .reloadLanguages:
            gitHubService.fetchLanguages(for: state.repository)
                .ignoreFailure()
                .sink { languages in self.state.languages = languages }
                .store(in: &cancellables)
        case .reloadComments:
            return
        }
    }
}

extension RepositoryViewViewModel {
    enum Input {
        case reloadContributors
        case reloadIssues
        case reloadPullRequests
        case reloadLanguages
        case reloadComments(Issue)
    }
}

extension RepositoryViewViewModel {
    struct State {
        let repository: Repository

        var contributors = [User]()
        var issues = [Issue]()
        var pullRequests = [PullRequest]()
        var languages = [String: Int]()
        var issueComments = [IssueComment]()
    }
}
