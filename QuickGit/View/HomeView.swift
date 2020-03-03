//
//  HomeView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    enum Tab {
        case profile
        case main
        case settings
    }

    @Binding var loginInformation: LoginInformation?

    let loginService: LoginService
    let gitHubService: GitHubService

    @State var selection = Tab.main

    var body: some View {
        TabView(selection: $selection) {
            profileTab
            mainTab
            settingsTab
        }
        .edgesIgnoringSafeArea(.top)
    }

    private var profileTab: some View {
        tab(ProfileView(loginInformation: $loginInformation, loginService: loginService, gitHubService: gitHubService), tab: .profile) { isSelected in
            Image(systemName: isSelected ? "person.fill" : "person")
            Text("Profile")
        }
    }

    private var mainTab: some View {
        tab(MainView(gitHubService: gitHubService), tab: .main) { isSelected in
            Image(systemName: isSelected ? "house.fill" : "house")
            Text("Main")
        }
    }

    private var settingsTab: some View {
        tab(SettingsView(), tab: .settings) { _ in
            Image(systemName: "gear")
            Text("Settings")
        }
    }

    private func tab<T: View, TabItem: View>(
        _ view: T,
        tab: Tab,
        @ViewBuilder tabItem: (Bool) -> TabItem
    ) -> some View {
        view.tag(tab)
            .tabItem { tabItem(self.selection == tab) }
    }
}
