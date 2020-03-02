//
//  LoginService.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine

struct LoginInformation {

}

protocol LoginService {
    func login(username: String, password: String) -> AnyPublisher<LoginInformation, Error>
}

class MockLoginService: LoginService {

    func login(username: String, password: String) -> AnyPublisher<LoginInformation, Error> {
        Just(LoginInformation())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

}
