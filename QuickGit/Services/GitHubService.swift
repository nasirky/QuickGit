//
//  GitHubService.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

protocol GitHubService {
    func fetchRepositories() -> AnyPublisher<[Repository], Error>
    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error>
}

class MockGitHubService: GitHubService {
    func fetchRepositories() -> AnyPublisher<[Repository], Error> {
        let repositories = [
            Repository(),
            Repository(),
            Repository(),
            Repository(),
            Repository(),
            Repository(),
            Repository(),
            Repository(),
        ]

        return .just(repositories)
    }

    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error> {
        let issues = [
            Issue(),
            Issue(),
            Issue(),
            Issue(),
            Issue(),
            Issue(),
            Issue(),
            Issue(),
            Issue(),
        ]

        return .just(issues)
    }
}
