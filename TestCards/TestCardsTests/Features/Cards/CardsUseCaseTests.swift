//
//  CardsUseCaseTests.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import XCTest
@testable import TestCards

class CardsUseCaseTests: XCTestCase {
    
    var useCase: CardsUseCase!
    var mockService: MockCardsService!
    var mockRepository: MockSavedCardsRepository!
    
    override func setUp() {
        super.setUp()
        mockService = MockCardsService()
        mockRepository = MockSavedCardsRepository()
        useCase = CardsUseCase(service: mockService, repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockService = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testGetCardsSuccess() async throws {
        // Arrange
        let card1 = DLCard(id: 1, uid: "uid1", credit_card_number: "123456", credit_card_expiry_date: "12/24", credit_card_type: "Visa")
        let card2 = DLCard(id: 2, uid: "uid2", credit_card_number: "987654", credit_card_expiry_date: "11/23", credit_card_type: "MasterCard")
        mockService.mockCards = [card1, card2]
        
        // Act
        let cards = try await useCase.getCards()
        
        // Assert
        XCTAssertEqual(cards.count, 2)
        XCTAssertEqual(cards.first?.cardId, card1.id)
        XCTAssertEqual(cards.last?.cardId, card2.id)
    }
    
    func testSaveCard() async throws {
        // Arrange
        let card = BOCard(cardId: 1, cardUId: "uid1", cardNumber: "123456", cardExpiryDate: "12/24", cardType: "Visa")
        
        // Act
        try await useCase.saveCard(card: card)
        
        // Assert
        XCTAssertEqual(mockRepository.mockSavedCards.count, 1)
        XCTAssertEqual(mockRepository.mockSavedCards.first?.id, card.cardId)
    }
    
    func testGetSavedCards() async throws {
        // Arrange
        let dlCard = DLCard(id: 1, uid: "uid1", credit_card_number: "123456", credit_card_expiry_date: "12/24", credit_card_type: "Visa")
        mockRepository.mockSavedCards = [dlCard]
        
        // Act
        let savedCards = try await useCase.getSavedCards()
        
        // Assert
        XCTAssertEqual(savedCards.count, 1)
        XCTAssertEqual(savedCards.first?.cardId, dlCard.id)
    }
    
    func testDeleteCard() async throws {
        // Arrange
        let dlCard = DLCard(id: 1, uid: "uid1", credit_card_number: "123456", credit_card_expiry_date: "12/24", credit_card_type: "Visa")
        mockRepository.mockSavedCards = [dlCard]
        
        // Act
        try await useCase.deleteCard(cardId: dlCard.id)
        let savedCards = try await useCase.getSavedCards()
        
        // Assert
        XCTAssertEqual(savedCards.count, 0)
    }
    
}

class MockCardsService: CardsServiceProtocol {
    
    var mockCards: [DLCard] = []
    
    func getCards() async throws -> [DLCard] {
        return mockCards
    }
}

class MockSavedCardsRepository: SavedCardsRepositoryProtocol {
    
    var mockSavedCards: [DLCard] = []
    
    func save(card: DLCard) throws {
        mockSavedCards.append(card)
    }
    
    func remove(cardId: Int) throws {
        mockSavedCards.removeAll { $0.id == cardId }
    }
    
    func getSavedCards() throws -> [DLCard] {
        return mockSavedCards
    }
}
