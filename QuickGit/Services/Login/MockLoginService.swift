//
//  MockLoginService.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

class MockLoginService: LoginService {

    func storedLogin() -> AnyPublisher<LoginInformation, Error> {
        Just(())
        .tryMap { throw LoginError.noStoredCredentials }
        .eraseToAnyPublisher()
    }

    func login(code: String) -> AnyPublisher<LoginInformation, Error> {
        .just(LoginInformation(accessToken: ""))
    }

    func logout() {}

}
