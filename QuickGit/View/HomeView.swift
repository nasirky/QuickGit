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

    var information: LoginInformation
    @State var selection = Tab.main

    var body: some View {
        TabView(selection: $selection) {
            tab(ProfileView(), tab: .profile) { isSelected in
                Image(systemName: isSelected ? "person.fill" : "person")
                Text("Profile")
            }

            tab(MainView(), tab: .main) { isSelected in
                Image(systemName: isSelected ? "house.fill" : "house")
                Text("Main")
            }

            tab(SettingsView(), tab: .settings) { _ in
                Image(systemName: "gear")
                Text("Settings")
            }
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
