//
//  User.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarURL = "avatar_url"
        case profileURL = "url"
        case contributions
        case reposURL = "repos_url"
    }

    let id: Int
    let username: String
    let avatarURL: String
    let profileURL: String
    let contributions: Int?
    let reposURL: String
}
