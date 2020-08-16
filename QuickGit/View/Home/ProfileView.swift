//
//  ProfileView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct ProfileView: View {

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<HomeViewModel.Input, Profile?>
    @State private var showLogoutAlert = false

    // MARK: Views

    var body: some View {
        NavigationView {
            Group {
                viewModel.state.map(profileView)
            }
            .onAppear { self.viewModel.trigger(.reloadProfile) }
            .navigationBarItems(leading: logoutButton, trailing: openInBrowserButton)
            .navigationBarTitle(Text(""), displayMode: .large)
        }
        .alert(isPresented: $showLogoutAlert, content: logoutAlert)
    }

    private func logoutAlert() -> Alert {
        Alert(title: Text("Logout"),
              message: Text("Do you really want to log out?"),
              primaryButton: .destructive(Text("Yes"), action: logout),
              secondaryButton: .default(Text("No")))
    }

    private var logoutButton: some View {
        Button(action: { self.showLogoutAlert = true }) {
            Image(systemName: "clear")
            .resizable()
            .scaledToFit()
        }
    }

    private var openInBrowserButton: some View {
        Button(action: openInBrowser) {
            Image(systemName: "globe")
            .resizable()
            .scaledToFit()
        }
    }

    private var loadingView: some View {
        Text("Loading...")
        .padding()
    }

    private func profileView(for profile: Profile) -> some View {
        ScrollView {
            VStack {
                header(for: profile)

                row(image: Image(systemName: "doc.plaintext"), text: profile.bio ?? "-")

                Divider()

                row(image: Image(systemName: "person.2.fill"), text: profile.company ?? "-")

                Divider()

                row(image: Image(systemName: "mappin.and.ellipse"), text: profile.location ?? "-")

                Divider()

                row(image: Image(systemName: "envelope.fill"), text: profile.email ?? "-")

                Divider()
            }
            .padding()
        }
    }

    private func row(image: Image, text: String) -> some View {
        HStack(spacing: 16) {
            image
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)

            Text(text.isEmpty ? "-" : text)

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .font(.headline)
    }

    private func header(for profile: Profile) -> some View {
        VStack(spacing: 16) {
            ProfileImage(url: profile.avatarURL, size: 80)

            VStack {
                Text(profile.name)
                .font(.title)

                Text(profile.login)
                .font(.headline)
            }

            Divider()

            informationRow(for: profile)

            Divider()
        }
    }

    private func informationRow(for profile: Profile) -> some View {
        HStack {
            Spacer()
            informationCell(title: "Repositories",
                            value: profile.publicRepositoryCount.description)
            Spacer()
            informationCell(title: "Followers",
                            value: profile.followerCount.description)
            Spacer()
            informationCell(title: "Following",
                            value: profile.followingCount.description)
            Spacer()
        }
    }

    private func informationCell(title: String, value: String) -> some View {
        VStack {
            Text(value)
            .font(.headline)

            Text(title)
            .font(.caption)
        }
    }

    // MARK: Helpers

    private func logout() {
        viewModel.trigger(.logout)
    }

    private func openInBrowser() {
        assertionFailure("Please adapt")
//        guard let url = store.state.profile.flatMap({ URL(string: $0.htmlURL) }) else {
//            return
//        }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}
