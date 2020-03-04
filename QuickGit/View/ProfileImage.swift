//
//  ProfileImage.swift
//  QuickGit
//
//  Created by Nasir on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct ProfileImage: View {
    let url: String?
    let width: Int
    let height: Int

    var body: some View {
        AsyncImage(
            size: CGSize(width: width, height: height),
            default: imageDefault,
            request: { self.loadAvatar(url: self.url) })
            .cornerRadius(40)
    }

    private var imageDefault: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(16)
            .background(Color.accentColor)
    }

    private func loadAvatar(url avatarURL: String?) -> AnyPublisher<Image, Never> {
         guard let url = avatarURL.flatMap(URL.init(string:)) else { return .empty() }
         return URLSession.shared.dataTaskPublisher(for: url)
             .compactMap { UIImage(data: $0.data).map(Image.init) }
             .ignoreFailure()
     }
}
