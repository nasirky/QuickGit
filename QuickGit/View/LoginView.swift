//
//  LoginView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct LoginView: View {

    @State var username: String = ""
    @State var password: String = ""
    @State var error: String?
    @State var cancellables = Set<AnyCancellable>()

    @Binding var information: LoginInformation?

    let loginService: LoginService

    var body: some View {
        NavigationView {
            Form {
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
                Button("Login", action: login)
            }
            .navigationBarTitle("Login")
        }
        .alert(item: $error) { error in
            Alert(title: Text(error))
        }
        .onAppear(perform: clear)
    }

    private func clear() {
        username = String()
        password = String()
    }

    private func login() {
        loginService
            .login(username: username, password: password)
            .mapResult()
            .sink { value in
                switch value {
                case let .success(information):
                    self.information = information
                case let .failure(error):
                    self.error = "Login failed\n\(error)"
                }

            }
            .store(in: &cancellables)
    }

}
