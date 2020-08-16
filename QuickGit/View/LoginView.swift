//
//  LoginView.swift
//  QuickGit
//
//  Created by Paul Kraft on 02.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

let request: URLRequest = {
    var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
    components.queryItems = [URLQueryItem(name: "client_id", value: Configuration.clientID)]
    return URLRequest(url: components.url!)
}()

struct LoginView: View {

    // MARK: Stored properties

    @ObservedObject var store: AppStore

    // MARK: Views

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Image("QuickGit")
                .resizable()
                .scaledToFit()
                .foregroundColor(.primary)
                .background(Color.accentColor)
                .frame(width: 128, height: 128)
                .cornerRadius(32)
                .padding(.bottom, 8)

                button(title: "Login", to: loginLink)
            }
            .padding(16)
            .frame(maxWidth: 500)
            .background(Color(.systemBackground).opacity(0.4))
            .cornerRadius(8)
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.accentColor)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(Text("QuickGit"), displayMode: .inline)
        }
    }

    private var loginLink: some View {
        AuthenticationView(initialRequest: request,
                           completion: login)
        .navigationBarTitle(Text("Login"), displayMode: .inline)
        .edgesIgnoringSafeArea(.all)
    }

    private func button<D: View>(title: String, to destination: D) -> some View {
        NavigationLink(destination: destination) {
            Text(title)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
        }
    }

    // MARK: Helpers

    private func login(code: String) {
        store.send(.login(code: code, store: store))
    }

}
