//
//  PullRequest.swift
//  QuickGit
//
//  Created by Nasir on 04.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct PullRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case state
        case isLocked = "locked"
        case title
        case body
        case user
        case head
        case base
    }

    let id: Int
    let state: String
    let isLocked: Bool
    let title: String
    let body: String
    let user: User

    let head: Branch
    let base: Branch
}

extension PullRequest {
    struct Branch: Codable {
        enum CodingKeys: String, CodingKey {
            case label
            case reference = "ref"
        }

        let label: String
        let reference: String
    }
}
