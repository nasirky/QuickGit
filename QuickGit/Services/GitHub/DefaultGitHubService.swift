//
//  DefaultGitHubService.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

enum Constants {
    static let baseURL = URL(string: "https://api.github.com")!
}

class DefaultGitHubService: GitHubService {

    // MARK: Nested types

    private enum Endpoint {
        case profile
        case repositories
        case issues(Repository)

        func url(for baseURL: URL) -> URL {
            switch self {
            case .profile:
                return baseURL
                    .appendingPathComponent("users")
            case .repositories:
                return baseURL
                    .appendingPathComponent("user/repos")
            case .issues(let repo):
                return baseURL
                    .appendingPathComponent("repos/:owner/\(repo.id)/issues")
            }
        }
    }

    // MARK: Stored properties

    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    // MARK: Methods

    func fetchProfile() -> AnyPublisher<Profile, Error> {
        request(at: .profile)
    }

    func fetchRepositories() -> AnyPublisher<[Repository], Error> {
        request(at: .repositories)
    }

    func fetchIssues(for repository: Repository) -> AnyPublisher<[Issue], Error> {
        request(at: .issues(repository))
    }

    // MARK: Helpers

    private func request(for endpoint: Endpoint) -> URLRequest {
        let url = endpoint.url(for: Constants.baseURL)
        let request = URLRequest(url: url)
        // TODO: Add authentication
        return request
    }

    private func request<D: Decodable>(at endpoint: Endpoint,
                                       for type: D.Type = D.self) -> AnyPublisher<D, Error> {
        session
            .dataTaskPublisher(for: request(for: endpoint))
            .map(\.data)
            .decode(type: type, decoder: decoder)
            .eraseToAnyPublisher()
    }

}
