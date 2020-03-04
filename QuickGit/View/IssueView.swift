//
//  IssueView.swift
//  QuickGit
//
//  Created by Paul Kraft on 04.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct IssueView: View {

    let repository: Repository
    let issue: Issue
    let gitHubService: GitHubService

    @State var cancellables = Set<AnyCancellable>()
    @State var comments = [IssueComment]()

    var body: some View {
        List(comments) { comment in
            Text(comment.body)
        }
        .navigationBarTitle(issue.title)
        .onAppear(perform: reload)
    }

    private func reload() {
        gitHubService.fetchComments(for: issue, in: repository)
        .ignoreFailure()
        .assign(to: \.comments, on: self)
        .store(in: &cancellables)
    }
}
