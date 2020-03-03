//
//  Profile.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation

struct Profile: Codable {

    // MARK: Nested types

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case name
        case company
        case location
        case email
        case bio
        case followerCount = "followers"
        case followingCount = "following"
        case publicRepositoryCount = "public_repos"
    }

    // MARK: Stored properties

    var id: Int
    var login: String
    var avatarURL: String?
    var htmlURL: String
    var name: String
    var company: String?
    var location: String?
    var email: String?
    var bio: String?
    var followerCount: Int
    var followingCount: Int
    var publicRepositoryCount: Int

}
