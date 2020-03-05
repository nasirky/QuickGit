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
            login:"pauljohanneskraft",
            avatarURL: "https://avatars2.githubusercontent.com/u/15239005?s=460&v=4",
            htmlURL: "https://github.com/pauljohanneskraft",
            name: "Paul",
            company: "@quickbirdstudios",
            location: "Munich, Germany",
            email: "",
            bio: "...",
            followerCount: 19,
            followingCount: 13,
            publicRepositoryCount: 4532)

        return .just(profile)
    }

    func fetchRepositories() -> AnyPublisher<[Repository], Error> {
        return .just([])
    }

    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error> {
        let issues = [Issue]()

        return .just(issues)
    }

    func fetchContributors(for repository: Repository) -> AnyPublisher<[User], Error> {
        .just([User]())
     }

    func fetchPullRequest(for repository: Repository) -> AnyPublisher<[PullRequest], Error> {
        .just([PullRequest]())
    }

    func fetchComments(for issue: Issue, in repository: Repository) -> AnyPublisher<[IssueComment], Error> {
        .just([])
    }

}
