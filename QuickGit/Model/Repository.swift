//
//  Repository.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct Repository: Codable {

    // MARK: Nested types

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case isFork = "fork"
        case forksCount = "forks_count"
        case starCount = "stargazers_count"
        case watcherCount = "watchers_count"
        case topics
    }

    // MARK: Stored properties

    var fullName: String
    var description: String
    var isFork: Bool
    var forksCount: Int
    var starCount: Int
    var watcherCount: Int
    var topics: [String]?

}
