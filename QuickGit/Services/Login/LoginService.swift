//
//  LoginService.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine

struct LoginInformation {
    var accessToken: String
}

enum LoginError: Error {
    case urlCreationFailed
    case noStoredCredentials
}

protocol LoginService {
    func storedLogin() -> AnyPublisher<LoginInformation, Error>
    func login(code: String) -> AnyPublisher<LoginInformation, Error>
    func logout()
}
