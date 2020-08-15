//
//  KeychainItem.swift
//  QuickGit
//
//  Created by Paul Kraft on 03.03.20.
//  Copyright © 2020 QuickBird Studios. All rights reserved.
//

import Combine
import Foundation

@propertyWrapper
struct KeychainItem {

    // MARK: Static properties

    private static let bundleID = Bundle.main.bundleIdentifier ?? "com.quickbirdstudios.QuickGit"

    // MARK: Stored properties

    let key: String
    let failurePublisher: AnyPublisher<Error, Never>

    private let failureSubject = PassthroughSubject<Error, Never>()

    // MARK: Computed properties

    var wrappedValue: String? {
        get {
            read(key: key)
        }
        set {
            save(newValue)
        }
    }

    // MARK: Initialization

    init(key: String) {
        self.key = key
        self.failurePublisher = failureSubject.eraseToAnyPublisher()
    }

    // MARK: Helpers

    private func save(_ value: String?) {
        do {
            if let value = value {
                try write(value: value, forKey: key)
            } else {
                try remove(forKey: key)
            }
        } catch {
            failureSubject.send(error)
        }
    }

    private func getItem(forKey account: String) -> KeychainPasswordItem? {
        let passwordItems = try? KeychainPasswordItem.passwordItems(forService: KeychainItem.bundleID)
        return passwordItems?.first { $0.account == account }
    }

    private func write(value: String, forKey key: String) throws {
        let item = getItem(forKey: key) ?? KeychainPasswordItem(service: KeychainItem.bundleID, account: key)
        return try item.savePassword(value)
    }

    private func remove(forKey key: String) throws {
        guard let item = getItem(forKey: key) else { return }
        try item.deleteItem()
    }

    private func read(key: String) -> String? {
        guard let item = getItem(forKey: key) else { return nil }
        return try? item.readPassword()
    }

}
