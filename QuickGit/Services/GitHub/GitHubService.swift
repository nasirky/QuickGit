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
    func fetchProfile() -> AnyPublisher<Profile, Error>
    func fetchRepositories() -> AnyPublisher<[Repository], Error>
    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error>

    func fetchContributors(for repository: Repository) -> AnyPublisher<[User], Error>
}
