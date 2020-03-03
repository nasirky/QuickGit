//
//  DefaultLoginService.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

private struct Token: Codable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

    var accessToken: String

}

class DefaultLoginService: LoginService {

    let session = URLSession.shared

    @KeychainItem(key: "access_token")
    var token

    func storedLogin() -> AnyPublisher<LoginInformation, Error> {
        guard let token = token else {
            return .failure(LoginError.noStoredCredentials)
        }
        return .just(LoginInformation(accessToken: token))
    }

    func login(code: String) -> AnyPublisher<LoginInformation, Error> {
        guard var components = URLComponents(string: "https://github.com/login/oauth/access_token") else {
            return .failure(LoginError.urlCreationFailed)
        }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: Configuration.clientID),
            URLQueryItem(name: "client_secret", value: Configuration.clientSecret),
            URLQueryItem(name: "code", value: code)
        ]

        guard let url = components.url else {
            return .failure(LoginError.urlCreationFailed)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Token.self, decoder: JSONDecoder())
            .map { LoginInformation(accessToken: $0.accessToken) }
            .handleEvents(receiveOutput: { [unowned self] in self.token = $0.accessToken })
            .eraseToAnyPublisher()
    }

    func logout() {
        token = nil
    }
    
}
