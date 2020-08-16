//
//  RepositoryView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI
import Combine

struct RepositoryView: View {

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>

    // MARK: Views

    var body: some View {
        List {
            header

            Section(header: Text("Contributors")) {
                ContributorsView(viewModel: viewModel)
            }

            Section(header: Text("Languages")) {
                LanguagesView(viewModel: viewModel)
            }


            Section(header: Text("Pull Requests")) {
                PullRequestsView(viewModel: viewModel)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(viewModel.state.repository.name), displayMode: .inline)
    }

    private var header: some View {
        VStack(alignment: .leading) {
            Text(viewModel.state.repository.description ?? "-")
            .font(.caption)
            .foregroundColor(.gray)

            topicSection

            Divider()

            statisticsSection
        }
        .padding(.vertical, 8)
    }

    private var topicSection: some View {
        viewModel.state.repository.topics.map { topics in
            ScrollView {
                HStack {
                    ForEach(topics) { topic in
                        Text(topic)
                        .padding(2)
                        .background(Color.accentColor.opacity(0.5).cornerRadius(8))
                        .padding(2)
                    }
                }
            }
        }
    }

    private var statisticsSection: some View {
        HStack {
            Spacer()
            statisticsCell(title: "Watchers", value: "\(viewModel.state.repository.watchersCount ?? 0)")
            Spacer()
            statisticsCell(title: "Stars", value: "\(viewModel.state.repository.starsCount ?? 0)")
            Spacer()
            statisticsCell(title: "Forks", value: "\(viewModel.state.repository.forksCount ?? 0)")
            Spacer()
        }
    }

    private func statisticsCell(title: String, value: String) -> some View {
        VStack {
            Text(value)
            .font(.headline)

            Text(title)
            .font(.caption)
        }
    }

}

struct ContributorsView: View {

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>

    // MARK: Views

    var body: some View {
        contentView(for: viewModel.state.contributors)
            .onAppear { self.viewModel.trigger(.reloadContributors) }
    }

    private func contentView(for contributors: [User]) -> some View {
        VStack {
            ForEach(contributors) { contributor in
                HStack {
                    ProfileImage(url: contributor.avatarURL, size: 40)

                    Text(contributor.username)

                    Spacer()

                    Text("\(contributor.contributions ?? 0) Contributions")
                    .foregroundColor(.gray)
                    .font(.caption)
                }
            }
        }
    }

}

struct IssuesView: View {

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>

    // MARK: Views

    var body: some View {
        VStack {
            ForEach(viewModel.state.issues) { issue in
                NavigationLink(destination: self.destination(for: issue)) {
                    self.cell(for: issue)
                }
            }
        }
        .onAppear { self.viewModel.trigger(.reloadIssues) }
    }

    private func destination(for issue: Issue) -> some View {
        IssueView(viewModel: viewModel, issue: issue)
    }

    private func cell(for issue: Issue) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(issue.title)

                Spacer()

                Text(issue.user.username)
                .foregroundColor(.gray)
            }

            Text(issue.body)
            .font(.footnote)
        }
        .padding(.top, 16)
    }

}

struct PullRequestsView: View {

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>

    // MARK: Views

    var body: some View {
        VStack {
            ForEach(viewModel.state.pullRequests) { pullRequest in
                self.cell(for: pullRequest)
            }
        }
    }

    private func cell(for pullRequest: PullRequest) -> some View {
        VStack(alignment: .leading) {
            Text(pullRequest.title)

            Text(pullRequest.body)
                .font(.caption)

            Text("\(pullRequest.user.username) wants to add commits from \(pullRequest.head.reference) into \(pullRequest.base.reference).")
                .font(.caption)
        }
    }

}

struct LanguagesView: View {

    @ObservedObject var viewModel: ViewModel<RepositoryViewViewModel.Input, RepositoryViewViewModel.State>

    var body: some View {
        let languages = viewModel.state.languages
        let sortedKeys: [String] = languages.sorted { $0.value > $1.value }.map { $0.key }
        let totalLines = languages.reduce(0) { result, keyValue in result + keyValue.value }

        return VStack {
            ForEach(sortedKeys, id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text(self.formattedPercentage(lines: languages[key] ?? 0, totalLines: totalLines))
                }
                .padding()
            }
        }.onAppear(perform: load)
    }

    private func formattedPercentage(lines: Int, totalLines: Int) -> String {
        let percentage = Double(lines) / Double(totalLines) * 100

        return String(format: "%.1f%%", percentage)
    }

    private func load() {
        viewModel.trigger(.reloadLanguages)
    }
}
