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

}
