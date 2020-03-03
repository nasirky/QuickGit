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

    private enum Endpoint {
        case profile
        case repositories
        case issues(Repository)

        func url(for baseURL: URL) -> URL {
            switch self {
            case .profile:
                return baseURL
                    .appendingPathComponent("user")
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
    private let information: LoginInformation

    // MARK: Initialization

    init(information: LoginInformation) {
        self.information = information
    }

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
        let url = endpoint.url(for: Configuration.baseURL)
        var request = URLRequest(url: url)
        request.addValue("token \(information.accessToken)",
                         forHTTPHeaderField: "Authorization")
        return request
    }

    private func request<D: Decodable>(at endpoint: Endpoint,
                                       for type: D.Type = D.self) -> AnyPublisher<D, Error> {
        session
            .dataTaskPublisher(for: request(for: endpoint))
            .map(\.data)
            .handleEvents(receiveOutput: { print(#function, endpoint, String(data: $0, encoding: .utf8) ?? "nil") })
            .decode(type: type, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .print()
            .eraseToAnyPublisher()
    }

}
