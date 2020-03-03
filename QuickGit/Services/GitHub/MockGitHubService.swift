//
//  MockGitHubService.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

class MockGitHubService: GitHubService {

    func fetchProfile() -> AnyPublisher<Profile, Error> {
        let profile = Profile(
            id: 1,
            login: "pauljohanneskraft",
            avatarURL: "https://avatars2.githubusercontent.com/u/15239005?s=460&v=4",
            htmlURL: "https://github.com/pauljohanneskraft",
            name: "Paul",
            company: "@quickbirdstudios",
            location: "Munich, Germany",
            email: "",
            bio: "...",
            followers: 19,
            following: 13
        )

        return .just(profile)
    }

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
