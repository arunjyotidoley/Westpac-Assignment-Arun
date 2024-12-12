//
//  SavedCardsRepositoryTests.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//
import XCTest
@testable import TestCards

class SavedCardsRepositoryTests: XCTestCase {
    
    var savedCardsRepository: SavedCardsRepository!
    var mockStorage: MockMemoryStorage!
    
    override func setUp() {
        super.setUp()
        mockStorage = MockMemoryStorage()
        savedCardsRepository = SavedCardsRepository(storage: mockStorage)
    }
    
    override func tearDown() {
        savedCardsRepository = nil
        mockStorage = nil
        super.tearDown()
    }
    
    func testSaveCardSuccessfully() throws {
        // Arrange
        let card = DLCard.init(id: 1, uid: "1", credit_card_number: "1234567890123456", credit_card_expiry_date: "12/25", credit_card_type: "Visa")
        
        // Act
        try savedCardsRepository.save(card: card)
        
        // Assert
        let savedCards = try savedCardsRepository.getSavedCards()
        XCTAssertEqual(savedCards.count, 1)
        XCTAssertEqual(savedCards.first?.id, card.id)
    }
    
    func testGetSavedCardsEmpty() throws {
        // Arrange
        // No cards saved
        
        // Act
        let savedCards = try savedCardsRepository.getSavedCards()
        
        // Assert
        XCTAssertTrue(savedCards.isEmpty)
    }
    
    func testSaveCardDuplicatesNotAdded() throws {
        // Arrange
        let card1 = DLCard.init(id: 1, uid: "1", credit_card_number: "1234567890123456", credit_card_expiry_date: "12/25", credit_card_type: "Visa")
        let card2 = DLCard.init(id: 1, uid: "1", credit_card_number: "1234567890123456", credit_card_expiry_date: "12/25", credit_card_type: "Visa") // Duplicate card
        
        // Act
        try savedCardsRepository.save(card: card1)
        try savedCardsRepository.save(card: card2)
        
        // Assert
        let savedCards = try savedCardsRepository.getSavedCards()
        XCTAssertEqual(savedCards.count, 1)
    }
    
    func testDeleteCard() throws {
        // Arrange
        let card1 = DLCard.init(id: 1, uid: "1", credit_card_number: "1234567890123456", credit_card_expiry_date: "12/25", credit_card_type: "Visa")
        let card2 = DLCard.init(id: 2, uid: "2", credit_card_number: "1234567890123456", credit_card_expiry_date: "12/25", credit_card_type: "mastercard")
        
        // Act
        try savedCardsRepository.save(card: card1)
        try savedCardsRepository.save(card: card2)
        try savedCardsRepository.remove(cardId: card1.id)
        
        // Assert
        let savedCards = try savedCardsRepository.getSavedCards()
        XCTAssertEqual(savedCards.count, 1)
        XCTAssertEqual(savedCards.first?.id, 2)
    }
}

class MockMemoryStorage: MemoryStorageProtocol {
    
    private var storage = [String: Any]()
    
    func save<T>(_ object: T, forKey key: String) throws {
        storage[key] = object
    }
    
    func retrieve<T>(forKey key: String) throws -> T? {
        return storage[key] as? T
    }
    
    func remove(forKey key: String) {
    }
    
    func clear() {
    }
    
}
