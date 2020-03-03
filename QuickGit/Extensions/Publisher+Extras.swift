//
//  Publisher+Extras.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine

extension Publisher {

    func mapResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
        .catch { Just(Result.failure($0)) }
        .eraseToAnyPublisher()
    }

    func ignoreFailure() -> AnyPublisher<Output, Never> {
        `catch` { _ in Empty() }
        .eraseToAnyPublisher()
    }

}

extension AnyPublisher {

    static func just(_ output: Output) -> AnyPublisher {
        Just(output)
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    }

    static func empty() -> AnyPublisher {
        Empty()
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    }

    static func failure(_ error: Failure) -> AnyPublisher {
        Just(())
        .tryMap { throw error }
        .mapError { $0 as! Failure }
        .eraseToAnyPublisher()
    }

}
