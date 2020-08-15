//
//  Store.swift
//  QuickGit
//
//  Created by Paul Kraft on 15.08.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

struct Change<State> {
    let perform: (inout State) -> Void
}

struct Reducer<State, Action> {
    typealias Change = QuickGit.Change<State>
    let reduce: (State, Action) -> AnyPublisher<Change, Never>
}

final class Store<State, Action>: ObservableObject {

    @Published private(set) var state: State
    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer
            .reduce(state, action)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: perform)
            .store(in: &cancellables)
    }

    private func perform(change: Reducer<State, Action>.Change) {
        change.perform(&state)
    }

}
