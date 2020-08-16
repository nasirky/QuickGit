//
//  RepositoryList.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct RepositoryList: View {

    // MARK: Stored properties

    @ObservedObject var store: AppStore

    // MARK: Views

    var body: some View {
        contentView(for: store.state.repositories)
            .onAppear { self.store.send(.reloadRepositories) }
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
        let destination = RepositoryView(store: store, repository: repository)
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
