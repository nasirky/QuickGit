//
//  AsyncImage.swift
//  QuickGit
//
//  Created by Paul Kraft on 04.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct AsyncImage<V: View>: View {

    // MARK: Stored properties

    let `default`: V
    let request: () -> AnyPublisher<Image, Never>

    @State private var image: Image? = nil
    @State private var cancellables = Set<AnyCancellable>()

    // MARK: Computed properties

    var body: some View {
        When(exists: image,
             then: { $0.resizable().scaledToFill() },
             else: `default`)
        .onAppear(perform: reload)
    }

    // MARK: Helpers

    private func reload() {
        request()
        .map(Optional.some)
        .assign(to: \.image, on: self)
        .store(in: &cancellables)
    }

}
