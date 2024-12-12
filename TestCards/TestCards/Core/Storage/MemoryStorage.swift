//
//  MemoryStorage.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//
import Foundation

protocol MemoryStorageProtocol {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func retrieve<T: Codable>(forKey key: String) throws -> T?
    func remove(forKey key: String)
    func clear()
}

final class MemoryStorage: MemoryStorageProtocol {
    
    static let shared = MemoryStorage()
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        storage[key] = data
    }

    func retrieve<T: Codable>(forKey key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try decoder.decode(T.self, from: data)
    }

    func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }

    func clear() {
        storage.removeAll()
    }
    
}
