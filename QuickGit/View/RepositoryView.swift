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
    let imageHelper = ImageHelper()

    var body: some View {
        ScrollView {
            header
                .padding()

            ContributorsView(gitHubService: gitHubService, repository: repository)
                .padding(.bottom, 10)
            Divider()
            IssuesView(gitHubService: gitHubService, repository: repository)
                .padding([.top, .bottom], 10)
        }
        .navigationBarTitle(Text(repository.fullName), displayMode: .inline)
    }

    private var header: some View {
        VStack(alignment: .leading) {
            Text(repository.description ?? "-")
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
    let imageHelper = ImageHelper()

    @State var contributors: [User] = []
    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            Section(header: Text("Contributors").fontWeight(.semibold)) {
                ForEach(contributors, id: \.id) { contributor in
                    HStack {
                        self.imageHelper.profileImage(url: contributor.avatarURL, width: 40, height: 40)
                            Text("\(contributor.username) - (\(contributor.contributions ?? 0) contributions)")
                                .padding(.leading, 10)
                            Spacer()
                        }.padding(.leading, 20)
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
            Section(header: Text("Issues").fontWeight(.semibold)) {
                ForEach(issues, id: \.id) { issue in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(issue.title)
                            Spacer()
                            Text(issue.user.username)
                        }
                        Text(issue.body)
                            .font(.footnote)

                    }.padding()
                }
            }
        }
        .onAppear(perform: load)
    }

    private func load() {
        gitHubService
            .fetchIssues(for: repository)
            .replaceError(with: [])
            .assign(to: \.issues, on: self)
            .store(in: &cancellables)
    }
}
