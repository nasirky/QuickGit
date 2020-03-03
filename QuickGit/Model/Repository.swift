//
//  Repository.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case isPrivate = "private"
        case htmlURL = "html_url"
        case url
        case description
        case isDisabled = "disabled"
        case topics
        case license

        case forksCount = "forks_count"
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case subscribersCount = "subscribers_count"
        case networkCount = "network_count"
        case openIssuesCount = "open_issues_count"
    }

    let id: Int
    let name: String
    let fullName: String
    let owner: User
    let isPrivate: Bool
    let htmlURL: String
    let url: String
    let description: String?
    let isDisabled: Bool?
    let topics: [String]?
    let license: License?

    let forksCount: Int?
    let starsCount: Int?
    let watchersCount: Int?
    let subscribersCount: Int?
    let networkCount: Int?
    let openIssuesCount: Int?

    // Note: all the optionals are due to public repositories
}

struct License: Codable {
    let key: String
    let name: String
    let url: String
}

extension Repository {
    var descriptionText: String {
        description ?? ""
    }
}
