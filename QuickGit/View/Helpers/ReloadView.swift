//
//  ReloadView.swift
//  QuickGit
//
//  Created by Paul Kraft on 05.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import SwiftUI

struct ReloadView<Model, ModelView: View>: View {

    // MARK: Stored properties

    @Binding var model: Model?
    let action: AnyPublisher<Model, Never>
    let create: (Model) -> ModelView

    @State private var cancellables = Set<AnyCancellable>()

    // MARK: Views

    var body: some View {
        When(exists: model,
             then: create,
             else: Text("Loading...").padding())
        .onAppear(perform: reload)
    }

    // MARK: Helpers

    private func reload() {
        action
        .map(Optional.some)
        .assign(to: \.model, on: self)
        .store(in: &cancellables)
    }

}
