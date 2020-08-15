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

    // MARK: User

    func fetchProfile() -> AnyPublisher<Profile, Error>

    // MARK: Repository

    func fetchRepositories() -> AnyPublisher<[Repository], Error>
    func fetchContributors(for repository: Repository) -> AnyPublisher<[User], Error>
    func fetchPullRequest(for repository: Repository) -> AnyPublisher<[PullRequest], Error>
    func fetchLanguages(for repository: Repository) -> AnyPublisher<[String: Int], Error>

    // MARK: Repository - Issue

    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error>
    func fetchComments(for issue: Issue, in repository: Repository) -> AnyPublisher<[IssueComment], Error>
}
