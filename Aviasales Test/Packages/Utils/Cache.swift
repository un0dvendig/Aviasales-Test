//
//  Cache.swift
//  Aviasales Test
//
//  Created by Eugene Ilyin on 13.10.2020.
//

import Foundation

// MARK: - Cache
final class Cache<Key: Hashable, Value> {
    // MARK: Private properties
    private let wrapped = NSCache<WrappedKey, Entry>()

    // MARK: Methods
    func insert(
        _ value: Value,
        forKey key: Key
    ) {
        let entry = Entry(
            value: value
        )
        self.wrapped.setObject(
            entry,
            forKey: WrappedKey(key)
        )
    }

    func value(
        forKey key: Key
    ) -> Value? {
        let entry = self.wrapped.object(
            forKey: WrappedKey(key)
        )
        return entry?.value
    }

    func removeValue(
        forKey key: Key
    ) {
        self.wrapped.removeObject(
            forKey: WrappedKey(key)
        )
    }

    func removeAll() {
        self.wrapped.removeAllObjects()
    }
}

// MARK: - Subscript
extension Cache {
    subscript(
        key: Key
    ) -> Value? {
        get {
            return self.value(
                forKey: key
            )
            
        }
        set {
            guard let value = newValue else {
                self.removeValue(
                    forKey: key
                )
                return
            }

            self.insert(
                value,
                forKey: key
            )
        }
    }
}

// MARK: - WrappedKey
extension Cache {
    private final class WrappedKey: NSObject {
        // MARK: Properties
        let key: Key

        // MARK: Initialization
        init(
            _ key: Key
        ) {
            self.key = key
        }

        override var hash: Int {
            return self.key.hashValue
            
        }

        override func isEqual(
            _ object: Any?
        ) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == self.key
        }
    }
}

// MARK: - Entry
extension Cache {
    private final class Entry {
        // MARK: Properties
        let value: Value

        // MARK: Initialization
        init(
            value: Value
        ) {
            self.value = value
        }
    }
}
