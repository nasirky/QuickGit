//
//  MainView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct MainView: View {

    // MARK: Stored properties

    let gitHubService: GitHubService

    @State private var repositories = [Repository]()
    @State private var cancellables = Set<AnyCancellable>()

    // MARK: Views

    var body: some View {
        ReloadView(action: gitHubService.fetchRepositories().ignoreFailure(),
                   create: contentView)
    }

    private func contentView(for repositories: [Repository]) -> some View {
        NavigationView {
            List(repositories) { repository in
                self.cell(for: repository)
            }
            .navigationBarTitle("Repositories")
        }
    }

    private func cell(for repository: Repository) -> some View {
        let destination = RepositoryView(repository: repository, gitHubService: gitHubService)
        return NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                Text(repository.fullName)
                .font(.headline)

                Text(repository.description ?? "")
                .font(.caption)
            }
        }
    }

}
