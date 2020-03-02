//
//  ContentView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var loginInformation: LoginInformation? = nil

    var body: some View {
        Group {
            if loginInformation == nil {
                LoginView(information: $loginInformation,
                          loginService: MockLoginService())
            }
            loginInformation.map { information in
                HomeView(information: information)
            }
        }
    }

}
