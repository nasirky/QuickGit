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
    func storedLogin() -> AnyPublisher<LoginInformation, Error>
    func login(username: String, password: String) -> AnyPublisher<LoginInformation, Error>
}

class MockLoginService: LoginService {

    func storedLogin() -> AnyPublisher<LoginInformation, Error> {
        .just(LoginInformation())
    }

    func login(username: String, password: String) -> AnyPublisher<LoginInformation, Error> {
        .just(LoginInformation())
    }

}
