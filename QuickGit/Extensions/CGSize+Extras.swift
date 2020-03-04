//
//  CGSize+Extras.swift
//  QuickGit
//
//  Created by Paul Kraft on 04.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import CoreGraphics

extension CGSize {
    static func square(_ length: CGFloat) -> CGSize {
        .init(width: length, height: length)
    }
}
