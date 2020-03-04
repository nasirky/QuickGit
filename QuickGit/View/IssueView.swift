//
//  IssueView.swift
//  QuickGit
//
//  Created by Paul Kraft on 04.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

extension RelativeDateTimeFormatter {
    static let `default`: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        return formatter
    }()
}

struct IssueView: View {

    let repository: Repository
    let issue: Issue
    let gitHubService: GitHubService

    @State var cancellables = Set<AnyCancellable>()
    @State var comments = [IssueComment]()

    var body: some View {
        List(comments) { comment in
            self.cell(for: comment)
        }
        .navigationBarTitle(issue.title)
        .onAppear(perform: reload)
    }

    private func cell(for comment: IssueComment) -> some View {
        VStack {
            HStack {
                ProfileImage(url: comment.user.avatarURL, size: 30)

                Text(comment.user.username)
                .font(.headline)

                Spacer()

                Text(RelativeDateTimeFormatter.default.localizedString(for: comment.creationDate, relativeTo: Date()))
                .font(.callout)
                .foregroundColor(.gray)
            }

            HStack {
                Text(comment.body)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.25))
            .cornerRadius(8)
        }
        .padding(.vertical, 8)
    }

    private func reload() {
        gitHubService.fetchComments(for: issue, in: repository)
        .print()
        .ignoreFailure()
        .assign(to: \.comments, on: self)
        .store(in: &cancellables)
    }
}
