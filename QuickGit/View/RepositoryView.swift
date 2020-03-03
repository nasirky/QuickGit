//
//  RepositoryView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

struct RepositoryView: View {

    let gitHubService: GitHubService
    let repository: Repository

    var body: some View {
        Text(repository.id)
        .navigationBarTitle(repository.id)
    }

}
