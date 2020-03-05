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
    let url = URL(string: "https://github.com/login/oauth/authorize")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    components.queryItems = [URLQueryItem(name: "client_id", value: Configuration.clientID)]
    return URLRequest(url: components.url!,
                      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                      timeoutInterval: 10)
}()

struct LoginView: View {

    // MARK: Stored properties

    @Binding var information: LoginInformation?

    let loginService: LoginService

    @State private var cancellables = Set<AnyCancellable>()

    // MARK: Views

    var body: some View {
        AuthenticationView(initialRequest: request,
                           completion: login)
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: Helpers

    private func login(code: String) {
        guard information == nil else { return }

        loginService.login(code: code)
        .ignoreFailure()
        .map(Optional.some)
        .assign(to: \.information, on: self)
        .store(in: &cancellables)
    }

}
