//
//  MemoryStorageTests.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import XCTest
@testable import TestCards

final class MemoryStorageTests: XCTestCase {
    private var memoryStorage: MemoryStorage!

    override func setUp() {
        super.setUp()
        memoryStorage = MemoryStorage.shared
        memoryStorage.clear()
    }

    override func tearDown() {
        memoryStorage.clear()
        memoryStorage = nil
        super.tearDown()
    }

    func testSaveAndRetrieveValue() throws {
        struct TestData: Codable, Equatable {
            let id: Int
            let name: String
        }
        let key = "testKey"
        let value = TestData(id: 1, name: "Test")
        try memoryStorage.save(value, forKey: key)
        let retrievedValue: TestData? = try memoryStorage.retrieve(forKey: key)
        XCTAssertEqual(retrievedValue, value, "Retrieved value should match the saved value")
    }

    func testRetrieveNonExistentKey() throws {
        let key = "nonExistentKey"
        let retrievedValue: String? = try memoryStorage.retrieve(forKey: key)
        XCTAssertNil(retrievedValue, "Retrieving a non-existent key should return nil")
    }

    func testRemoveValue() throws {
        struct TestData: Codable, Equatable {
            let id: Int
            let name: String
        }
        let key = "testKey"
        let value = TestData(id: 1, name: "Test")
        try memoryStorage.save(value, forKey: key)
        memoryStorage.remove(forKey: key)
        let retrievedValue: TestData? = try memoryStorage.retrieve(forKey: key)
        XCTAssertNil(retrievedValue, "Value should be nil after being removed")
    }

    func testClearStorage() throws {
        struct TestData: Codable, Equatable {
            let id: Int
            let name: String
        }

        let key1 = "key1"
        let key2 = "key2"
        let value1 = TestData(id: 1, name: "Test1")
        let value2 = TestData(id: 2, name: "Test2")

        try memoryStorage.save(value1, forKey: key1)
        try memoryStorage.save(value2, forKey: key2)

        memoryStorage.clear()

        let retrievedValue1: TestData? = try memoryStorage.retrieve(forKey: key1)
        let retrievedValue2: TestData? = try memoryStorage.retrieve(forKey: key2)

        XCTAssertNil(retrievedValue1, "All values should be removed after clear")
        XCTAssertNil(retrievedValue2, "All values should be removed after clear")
    }

    func testSaveThrowsErrorForEncodingFailure() {
        struct FailingEncodable: Codable {
            func encode(to encoder: Encoder) throws {
                throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Deliberate encoding failure"))
            }
        }

        let key = "failingEncodableKey"
        let value = FailingEncodable()

        XCTAssertThrowsError(
            try memoryStorage.save(value, forKey: key),
            "Saving an encodable type that throws during encoding should throw an error"
        ) { error in
            XCTAssertTrue(error is EncodingError, "Error should be of type EncodingError")
        }
    }
    
}
