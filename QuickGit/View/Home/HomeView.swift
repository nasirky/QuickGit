//
//  HomeView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    // MARK: Nested types

    enum Tab {
        case profile
        case repositoryList
        case settings
    }

    // MARK: Stored properties

    @ObservedObject var viewModel: ViewModel<HomeViewModel.Input, HomeViewModel.State>

    @State var selection = Tab.profile

    // MARK: Views

    var body: some View {
        TabView(selection: $selection) {
            profileTab
            repositoryListTab
            settingsTab
        }
    }

    private var profileTab: some View {

        return tab(ProfileView(viewModel: viewModel), tab: .profile) { isSelected in
            Image(systemName: isSelected ? "person.fill" : "person")
            Text("Profile")
        }
    }

    private var repositoryListTab: some View {
        tab(RepositoryList(viewModel: viewModel), tab: .repositoryList) { isSelected in
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