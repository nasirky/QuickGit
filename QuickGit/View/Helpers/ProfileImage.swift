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

    // MARK: Stored properties

    let url: String?
    let size: CGFloat

    // MARK: Computed properties

    var body: some View {
        AsyncImage(
            default: imageDefault,
            request: { self.loadAvatar(url: self.url) })
        .frame(width: size, height: size)
        .cornerRadius(size / 2)
    }

    private var imageDefault: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .padding(16)
            .background(Color.accentColor)
    }

    // MARK: Helpers

    private func loadAvatar(url avatarURL: String?) -> AnyPublisher<Image, Never> {
         guard let url = avatarURL.flatMap(URL.init(string:)) else { return .empty() }
         return URLSession.shared.dataTaskPublisher(for: url)
             .compactMap { UIImage(data: $0.data).map(Image.init) }
             .ignoreFailure()
     }

}
