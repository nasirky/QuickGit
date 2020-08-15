//
//  DefaultGitHubService.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

class DefaultGitHubService: GitHubService {

    // MARK: Nested types

    private enum Endpoint: NetworkEndpoint {
        case profile
        case repositories
        case issues(Repository)
        case contributors(Repository)
        case pullRequest(Repository)
        case issueComments(Repository, Issue)
        case languages(Repository)

        func url(for baseURL: URL) -> URL {
            switch self {
            case .profile:
                return baseURL
                    .appendingPathComponent("user")
            case .repositories:
                return baseURL
                    .appendingPathComponent("user")
                    .appendingPathComponent("repos")
            case .issues(let repo):
                return baseURL
                    .appendingPathComponent("repos")
                    .appendingPathComponent(repo.owner.username)
                    .appendingPathComponent(repo.name)
                    .appendingPathComponent("issues")
            case .contributors(let repo):
                return baseURL
                    .appendingPathComponent("repos")
                    .appendingPathComponent(repo.owner.username)
                    .appendingPathComponent(repo.name)
                    .appendingPathComponent("contributors")
            case .pullRequest(let repo):
                return baseURL
                    .appendingPathComponent("repos")
                    .appendingPathComponent(repo.owner.username)
                    .appendingPathComponent(repo.name)
                    .appendingPathComponent("pulls")
            case .issueComments(let repo, let issue):
                return Endpoint.issues(repo).url(for: baseURL)
                    .appendingPathComponent(issue.number.description)
                    .appendingPathComponent("comments")
            case .languages(let repo):
                return baseURL
                    .appendingPathComponent("repos/\(repo.owner.username)/\(repo.name)/languages")
            }
        }
    }

    // MARK: Stored properties

    private let information: LoginInformation

    private lazy var network: NetworkService<Endpoint> = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return NetworkService(
            baseURL: Configuration.baseURL,
            authorization: "token " + information.accessToken,
            decoder: decoder)
    }()

    // MARK: Initialization

    init(information: LoginInformation) {
        self.information = information
    }

    // MARK: Methods

    func fetchProfile() -> AnyPublisher<Profile, Error> {
        network.request(at: .profile)
    }

    func fetchRepositories() -> AnyPublisher<[Repository], Error> {
        network.request(at: .repositories)
    }

    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error> {
        network.request(at: .issues(repository))
    }

    func fetchComments(for issue: Issue,
                       in repository: Repository) -> AnyPublisher<[IssueComment], Error> {
        network.request(at: .issueComments(repository, issue))
    }

    func fetchContributors(for repository: Repository) -> AnyPublisher<[User], Error> {
        network.request(at: .contributors(repository))
    }

    func fetchPullRequest(for repository: Repository) -> AnyPublisher<[PullRequest], Error> {
        network.request(at: .pullRequest(repository))
    }


    func fetchLanguages(for repository: Repository) -> AnyPublisher<[String : Int], Error> {
        network.request(at: .languages(repository))
    }

}
