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
    let gitHubService: GitHubService

    var body: some View {
        NavigationView {
            ZStack {
                profile
                .map(profileView)

                if profile == nil {
                    loadingView
                }
            }
            .navigationBarItems(trailing: openInBrowserButton)
            .navigationBarTitle(Text(""), displayMode: .large)
        }
        .onAppear(perform: reload)
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

                row(image: Image(systemName: "doc.plaintext"), text: profile.bio)

                Divider()

                row(image: Image(systemName: "person.2.fill"), text: profile.company)

                Divider()

                row(image: Image(systemName: "mappin.and.ellipse"), text: profile.location)

                Divider()

                row(image: Image(systemName: "envelope.fill"), text: profile.email)

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
            image(for: profile)

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

            VStack {
                Text(profile.following.description) // TODO
                .font(.headline)

                Text("Repositories")
                .font(.caption)
            }

            Spacer()

            VStack {
                Text(profile.followers.description)
                .font(.headline)

                Text("Followers")
                .font(.caption)
            }

            Spacer()

            VStack {
                Text(profile.following.description)
                .font(.headline)

                Text("Following")
                .font(.caption)
            }

            Spacer()
        }
    }

    private func image(for profile: Profile) -> some View {
        AsyncImage(
            size: CGSize(width: 80, height: 80),
            default: imageDefault,
            request: { self.loadAvatar(for: profile) })
        .cornerRadius(40)
    }

    private var imageDefault: some View {
        Image(systemName: "person.fill")
        .resizable()
        .scaledToFit()
        .padding(16)
        .background(Color.accentColor)
    }

    private func loadAvatar(for profile: Profile) -> AnyPublisher<Image, Never> {
        guard let url = URL(string: profile.avatarURL) else { return .empty() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { UIImage(data: $0.data).map(Image.init) }
            .ignoreFailure()
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
