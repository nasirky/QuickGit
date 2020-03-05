//
//  When.swift
//  QuickGit
//
//  Created by Paul Kraft on 05.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

struct When<ThenView: View, ElseView: View>: View {

    // MARK: Stored properties

    let thenView: ThenView?
    let elseView: ElseView?

    // MARK: Computed properties

    var body: some View {
        Group {
            thenView
            elseView
        }
    }

    // MARK: Initialization

    init(_ condition: Bool,
         then thenView: @autoclosure () -> ThenView,
         else elseView: @autoclosure () -> ElseView) {
        self.thenView = condition ? thenView() : nil
        self.elseView = condition ? nil : elseView()
    }

    init<Value>(
        exists value: Value,
        then thenView: (Value.Wrapped) -> ThenView,
        else elseView: @autoclosure () -> ElseView
    ) where Value: OptionalType {
        self.thenView = value.asOptional.map(thenView)
        self.elseView = value.asOptional == nil ? elseView() : nil
    }

}
