//
//  Issue.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct Issue: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let url: URL
    let user: User
    let number: Int
    let assignees: [User]?

}

struct IssueComment: Codable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case id, body, user
        case creationDate = "created_at"
        case updateDate = "updated_at"
    }

    let id: Int
    let body: String
    let user: User
    let creationDate: Date
    let updateDate: Date
}
