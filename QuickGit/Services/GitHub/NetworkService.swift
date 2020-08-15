//
//  NetworkService.swift
//  QuickGit
//
//  Created by Paul Kraft on 05.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

protocol NetworkEndpoint {
    func url(for baseURL: URL) throws -> URL
}

class NetworkService<Endpoint: NetworkEndpoint> {

    // MARK: Stored properties

    let session: URLSession
    let baseURL: URL
    let authorization: String?
    let decoder: JSONDecoder

    // MARK: Initialization

    init(baseURL: URL,
         authorization: String? = nil,
         session: URLSession = .shared,
         decoder: JSONDecoder = .init()) {
        self.session = session
        self.baseURL = baseURL
        self.authorization = authorization
        self.decoder = decoder
    }

    // MARK: Methods

    func request<D: Decodable>(at endpoint: Endpoint,
                               as type: D.Type = D.self) -> AnyPublisher<D, Error> {
        do {
            let urlRequest = try request(for: endpoint)
            return session
                .dataTaskPublisher(for: urlRequest)
                .map(\.data)
                .decode(type: type, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .printOnFailure()
                .eraseToAnyPublisher()
        } catch {
            return .failure(error)
        }
    }

    // MARK: Helpers

    private func request(for endpoint: Endpoint) throws -> URLRequest {
        let url = try endpoint.url(for: baseURL)
        var request = URLRequest(url: url)
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        return request
    }

}
