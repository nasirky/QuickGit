//
//  MainView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

extension Repository: Identifiable {
    var id: String {
        return fullName
    }
}

struct MainView: View {

    @State var repositories = [Repository]()
    @State var cancellables = Set<AnyCancellable>()

    let gitHubService: GitHubService

    var body: some View {
        NavigationView {
            List(repositories) { repository in
                self.cell(for: repository)
            }
            .navigationBarTitle("Repositories")
        }
        .onAppear(perform: reload)
    }

    private func cell(for repository: Repository) -> some View {
        let destination = RepositoryView(gitHubService: gitHubService, repository: repository)
        return NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                Text(repository.fullName)
                .font(.headline)

                Text(repository.description)
                .font(.caption)
            }
        }
    }

    private func reload() {
        gitHubService.fetchRepositories()
        .replaceError(with: [])
        .assign(to: \.repositories, on: self)
        .store(in: &cancellables)
    }

}
