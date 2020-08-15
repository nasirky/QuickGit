//
//  OptionalType.swift
//  QuickGit
//
//  Created by Paul Kraft on 05.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

protocol OptionalType {
    associatedtype Wrapped
    var asOptional: Wrapped? { get }
}

extension Optional: OptionalType {
    var asOptional: Wrapped? { self }
}
