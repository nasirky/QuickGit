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

    let gitHubService: GitHubService
    let repository: Repository

    var body: some View {
//        ScrollView {
        VStack {

            List {
                header

                Section(header: Text("Contributors")) {
                    ContributorsView(gitHubService: gitHubService, repository: repository)
                }

                Section(header: Text("Pull Requests")) {
                    PullRequestsView(gitHubService: gitHubService, repository: repository)
                }

                Section(header: Text("Issues")) {
                    IssuesView(gitHubService: gitHubService, repository: repository)
                }
            }
            .listStyle(GroupedListStyle())
            }

//            Divider()
//

        .navigationBarTitle(Text(repository.fullName), displayMode: .inline)
    }

    private var header: some View {
        VStack(alignment: .leading) {
            Text(repository.description ?? "No")
            .font(.caption)
            .foregroundColor(.gray)

            topicSection

            Divider()

            statisticsSection

            Divider()
        }
    }

    private var topicSection: some View {
        repository.topics.map { topics in
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
            statisticsCell(title: "Watchers", value: "\(repository.watchersCount ?? 0)")
            Spacer()
            statisticsCell(title: "Stars", value: "\(repository.starsCount ?? 0)")
            Spacer()
            statisticsCell(title: "Forks", value: "\(repository.forksCount ?? 0)")
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
    let gitHubService: GitHubService
    let repository: Repository

    @State var contributors: [User] = []
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
                ForEach(contributors, id: \.id) { contributor in
                    HStack {
                        ProfileImage(url: contributor.avatarURL, width: 40, height: 40)
                        Text(contributor.username)
                        Spacer()
                         Text("\(contributor.contributions ?? 0) Contributions")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                 }
        }
        .onAppear(perform: load)
    }

    private func load() {
        gitHubService
            .fetchContributors(for: repository)
            .replaceError(with: [])
            .assign(to: \.contributors, on: self)
            .store(in: &cancellables)
    }
}

struct IssuesView: View {
    let gitHubService: GitHubService
    let repository: Repository

    @State var issues: [Issue] = [] 
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            ForEach(issues, id: \.id) { issue in
                VStack(alignment: .leading) {
                    HStack {
                        Text(issue.title)
                        Spacer()
                        Text(issue.user.username)
                            .foregroundColor(.gray)
                    }
                    Text(issue.body)
                        .font(.footnote)
                }.padding(.top, 16)
            }
        }.onAppear(perform: load)
    }

    private func load() {
        gitHubService
            .fetchIssues(for: repository)
            .replaceError(with: [])
            .assign(to: \.issues, on: self)
            .store(in: &cancellables)
    }
}

struct PullRequestsView: View {
    let gitHubService: GitHubService
    let repository: Repository

    @State var pullRequests: [PullRequest] = []
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            ForEach(pullRequests, id: \.id) { pullRequest in
                VStack(alignment: .leading) {
                    Text(pullRequest.title)
                    Text(pullRequest.body)
                        .font(.caption)

                    Text("\(pullRequest.user.username) wants to add commits from \(pullRequest.head.reference) into \(pullRequest.base.reference).")
                        .font(.caption)

                }
            }
        }.onAppear(perform: load)
    }

    private func load() {
        gitHubService
            .fetchPullRequest(for: repository)
            .replaceError(with: [])
            .assign(to: \.pullRequests, on: self)
            .store(in: &cancellables)
    }
}
