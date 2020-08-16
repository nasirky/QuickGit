//
//  AnyViewModel.swift
//  QuickGit
//
//  Created by Nasir on 16.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Foundation
import Combine

class ViewModel<Input, State>: ObservableObject, Identifiable {

    var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    @Published var state: State

    init(state: State) {
        self.state = state
    }

    func trigger(_ input: Input) {
        assertionFailure("Please implement this!")
    }
}
