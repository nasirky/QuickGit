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
        ScrollView {
            header
            .padding()
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
