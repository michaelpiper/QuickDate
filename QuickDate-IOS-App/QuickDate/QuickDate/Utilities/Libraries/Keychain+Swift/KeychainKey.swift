//
//  KeychainKey.swift
//  Key Chain
//
//  Created by Nazmi Yavuz on 14.11.2021.
//  Copyright © 2021 Nazmi Yavuz. All rights reserved.

import Foundation

public class KeychainKey{}

/// Represents a `Key` with an associated generic value type conforming to the
/// `Codable` protocol.
///
///     static let someKey = Key<ValueType>("someKey")
public final class ChainKey<ValueType: Codable>: KeychainKey {
    fileprivate let _key: String
    public init(_ key: String) {
        _key = key
    }
}

public final class Keychain {
    
    private var keychain: KeychainSwift
    
    /// Shared instance of `Keychain`, used for ad-hoc access to the user's
    /// defaults database throughout the app.
    public static let shared = Keychain()
    
    /// Keychain initializer to handle class with app name.
    /// - Parameter keychain: KeychainSwift with keyPrefix. You have to change prefix name  for each app
    public init(keychain: KeychainSwift = KeychainSwift(keyPrefix: "libraries_")) {
        self.keychain = keychain
        self.keychain.synchronizable = false
        self.keychain.accessGroup = nil
    }
    
    public func allKeys() -> [String] {
        return keychain.allKeys
    }
    
    /// Deletes the value associated with the specified key, if any.
    ///
    /// - Parameter key: The key.
    public func delete<ValueType>(_ key: ChainKey<ValueType>) {
        keychain.delete(key._key)
    }
    
    /// Delete everything from app's Keychain.
    public func clear() {
        keychain.clear()
    }
    
    /// Returns the value associated with the specified key.
    ///
    /// - Parameter key: The key.
    /// - Returns: A `ValueType` or nil if the key was not found.
    public func get<ValueType>(for key: ChainKey<ValueType>) -> ValueType? {
        
        if isSwiftCodableType(ValueType.self) || isFoundationCodableType(ValueType.self) {
            
            if isBool(ValueType.self) {
                return keychain.getBool(key._key) as? ValueType
            } else {
                if isInt(ValueType.self) {
                    let value = Int(keychain.get(key._key) ?? "0")
                    return value as? ValueType
                } else if isDouble(ValueType.self) {
                    let value = Double(keychain.get(key._key) ?? "0.0")
                    return value as? ValueType
                } else if isFloat(ValueType.self) {
                    let value = Float(keychain.get(key._key) ?? "0.0")
                    return value as? ValueType
                }
                return keychain.get(key._key) as? ValueType
            }
            
        }

        guard let data = keychain.getData(key._key) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            #if DEBUG
                print(error)
            #endif
        }

        return nil

    }
    
    /// Sets a value associated with the specified key.
    ///
    /// - Parameters:
    ///   - some: The value to set.
    ///   - key: The associated `Key<ValueType>`.
    public func set<ValueType>(_ value: ValueType, for key: ChainKey<ValueType>,
                               with access: KeychainSwiftAccessOptions? = nil) {
        if isSwiftCodableType(ValueType.self) || isFoundationCodableType(ValueType.self) {
            if isBool(ValueType.self) {
                let boolValue = value as? Bool ?? false
                keychain.set(boolValue, forKey: key._key, withAccess: access)
                return
            } else {
                let text = String(describing: value)
                keychain.set(text, forKey: key._key, withAccess: access)
                return
            }
        }

        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(value)
            keychain.set(encoded, forKey: key._key, withAccess: access)
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    private func isBool<ValueType>(_ type: ValueType.Type) -> Bool {
        return type is Bool.Type
    }
    
    private func isInt<ValueType>(_ type: ValueType.Type) -> Bool {
        return type is Int.Type
    }
    
    private func isDouble<ValueType>(_ type: ValueType.Type) -> Bool {
        return type is Double.Type
    }
    
    private func isFloat<ValueType>(_ type: ValueType.Type) -> Bool {
        return type is Float.Type
    }
    
    /// Checks if the specified type is a Codable from the Swift standard library.
    ///
    /// - Parameter type: The type.
    /// - Returns: A boolean value.
    private func isSwiftCodableType<ValueType>(_ type: ValueType.Type) -> Bool {
        switch type {
        case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type:
            return true
        default:
            return false
        }
    }

    /// Checks if the specified type is a Codable, from the Swift's core libraries
    /// Foundation framework.
    ///
    /// - Parameter type: The type.
    /// - Returns: A boolean value.
    private func isFoundationCodableType<ValueType>(_ type: ValueType.Type) -> Bool {
        switch type {
        case is Date.Type:
            return true
        default:
            return false
        }
    }
}
