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

    @State var profile: Profile?
    @State var cancellables = Set<AnyCancellable>()
    @State var showLogoutAlert = false
    @Binding var loginInformation: LoginInformation?

    let loginService: LoginService
    let gitHubService: GitHubService
    let imageHelper = ImageHelper()
    
    var body: some View {
        NavigationView {
            ZStack {
                profile
                .map(profileView)

                if profile == nil {
                    loadingView
                }
            }
            .navigationBarItems(leading: logoutButton, trailing: openInBrowserButton)
            .navigationBarTitle(Text(""), displayMode: .large)
        }
        .alert(isPresented: $showLogoutAlert, content: logoutAlert)
        .onAppear(perform: reload)
    }

    private func logout() {
        self.loginService.logout()
        self.loginInformation = nil
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

    private func openInBrowser() {
        guard let url = profile.flatMap({ URL(string: $0.htmlURL) }) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
            imageHelper.profileImage(url: profile.avatarURL)

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

    private func reload() {
        gitHubService.fetchProfile()
        .ignoreFailure()
        .map(Optional.some)
        .assign(to: \.profile, on: self)
        .store(in: &cancellables)
    }

}


struct AsyncImage<V: View>: View {

    @State
    private var image: Image? = nil

    @State
    private var cancellables = Set<AnyCancellable>()

    let size: CGSize
    let `default`: V
    let request: () -> AnyPublisher<Image, Never>

    var body: some View {
        Group {
            image.map { image in
                image
                .resizable()
                .scaledToFill()
            }

            if image == nil {
                `default`
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear(perform: reload)
    }

    private func reload() {
        request()
        .map(Optional.some)
        .assign(to: \.image, on: self)
        .store(in: &cancellables)
    }

}
