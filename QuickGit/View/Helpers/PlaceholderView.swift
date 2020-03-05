//
//  PlaceholderView.swift
//  QuickGit
//
//  Created by Paul Kraft on 05.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import SwiftUI

protocol PlaceholderView: View {}

extension PlaceholderView {

    var body: some View {
        NavigationView {
            Text(String(describing: Self.self))
            .navigationBarTitle(String(describing: Self.self))
        }
    }

}
