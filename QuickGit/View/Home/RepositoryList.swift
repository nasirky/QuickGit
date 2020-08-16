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

    @ObservedObject var viewModel: ViewModel<HomeViewModel.Input, HomeViewModel.State>

    // MARK: Views

    var body: some View {
        contentView(for: viewModel.state.repositoryViewModels)
            .onAppear { self.viewModel.trigger(.reloadRepositories) }
    }

    private func contentView(for repositoryViewModels: [ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>]) -> some View {
        NavigationView {
            List(repositoryViewModels) { repositoryViewModel in
                self.cell(for: repositoryViewModel)
            }
            .navigationBarTitle("Repositories")
        }
    }

    private func cell(for repositoryViewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State> ) -> some View {
        let destination = RepositoryView(viewModel: repositoryViewModel)
        return NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                Text(repositoryViewModel.state.repository.fullName)
                .font(.headline)

                Text(repositoryViewModel.state.repository.description ?? "")
                .font(.caption)
            }
        }
    }

}
