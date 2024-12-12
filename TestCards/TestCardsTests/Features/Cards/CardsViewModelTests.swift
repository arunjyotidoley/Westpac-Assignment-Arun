//
//  CardsViewModelTests.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import XCTest
@testable import TestCards

@MainActor
class CardsViewModelTests: XCTestCase {
    
    var viewModel: CardsViewModel!
    var mockCardsUseCase: MockCardsUseCase!
    
    override func setUp() {
        super.setUp()
        mockCardsUseCase = MockCardsUseCase()
        viewModel = CardsViewModel(cardsUseCase: mockCardsUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockCardsUseCase = nil
        super.tearDown()
    }
    
    func loadCards(cards: [MockDTOCard], savedCards: [MockDTOCard]) async {
        mockCardsUseCase.mockCards = cards
        mockCardsUseCase.mockSavedCards = savedCards
        await viewModel.load()
    }
    
    func testLoadCardsSuccessfully() async {
        // Arrange
        let mockCards = [
            MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"),
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        let mockSavedCards = [
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        await loadCards(cards: mockCards, savedCards: mockSavedCards)
        
        // Assert
        XCTAssertEqual(viewModel.state, .loaded(UIOAllCards(cards: mockCards.map { UIOCard(dto: $0) }, savedCards: mockSavedCards.map { UIOCard(dto: $0) })))
    }
    
    func testLoadCardsFails() async {
        // Arrange
        mockCardsUseCase.mockError = FeatureError(statusCode: 500, description: "Loading error")
        
        // Act
        await viewModel.load()
        
        // Assert
        XCTAssertEqual(viewModel.state, .failed(FeatureError(statusCode: 500, description: "Loading error")))
    }
    
    func testSaveCardSuccessfully() async {
        // Arrange
        let mockCards = [
            MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"),
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        let cardToSave = UIOCard(dto: MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"))
        await loadCards(cards: mockCards, savedCards: [])
        
        // Act
        await viewModel.saveCard(cardToSave)
        
        // Assert
        XCTAssertEqual(viewModel.state, .loaded(UIOAllCards(cards: mockCards.map { UIOCard(dto: $0) }, savedCards: [cardToSave])))
    }
    
    func testSaveCardFails() async {
        // Arrange
        let cardToSave = UIOCard(dto: MockDTOCard(cardId: 3, cardUId: "UID125", cardNumber: "3456789012345678", cardExpiryDate: "10/24", cardType: "Discover"))
        mockCardsUseCase.mockError = FeatureError(statusCode: 500, description: "Saving error")
        
        // Act
        await viewModel.saveCard(cardToSave)
        
        // Assert
        XCTAssertEqual(viewModel.state, .failed(FeatureError(statusCode: 500, description: "Saving error")))
    }
    
    func testIsSavedReturnsTrue() async {
        // Arrange
        let mockCards = [
            MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"),
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        let cardToSave = UIOCard(dto: MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"))
        await loadCards(cards: mockCards, savedCards: [])
        await viewModel.saveCard(cardToSave)
        
        // Act & Assert
        XCTAssertTrue(viewModel.isSaved(cardToSave))
    }
    
    func testIsSavedReturnsFalse() async {
        // Arrange
        let mockCards = [
            MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"),
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        let unsavedCard = UIOCard(dto: MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"))
        await loadCards(cards: mockCards, savedCards: [])
        
        // Act & Assert
        XCTAssertFalse(viewModel.isSaved(unsavedCard))
    }
    
    func testCardDeleteSuccessfully() async {
        // Arrange
        let mockCards = [
            MockDTOCard(cardId: 1, cardUId: "UID123", cardNumber: "1234567890123456", cardExpiryDate: "12/25", cardType: "Visa"),
            MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        ]
        let cardToSave = MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        let cardToDelete = UIOCard(dto: cardToSave)
        await loadCards(cards: mockCards, savedCards: [cardToSave])
        
        // Act
        await viewModel.removeCard(cardToDelete)
        
        //Assert
        XCTAssertEqual(viewModel.state, .loaded(UIOAllCards(cards: mockCards.map { UIOCard(dto: $0) }, savedCards: [])))
    }
    
    func testCardDeleteFailure() async {
        // Arrange
        mockCardsUseCase.mockError = FeatureError(statusCode: 500, description: "Delete error")
        let cardToSave = MockDTOCard(cardId: 2, cardUId: "UID124", cardNumber: "2345678901234567", cardExpiryDate: "11/26", cardType: "MasterCard")
        let cardToDelete = UIOCard(dto: cardToSave)

        // Act
        await viewModel.removeCard(cardToDelete)
        // Assert
        XCTAssertEqual(viewModel.state, .failed(FeatureError(statusCode: 500, description: "Delete error")))
    }
    
    func testSortCardsByType() async {
        // Arrange
        let cards = [
            MockDTOCard(cardId: 1, cardUId: "UID1", cardNumber: "3456789012345678", cardExpiryDate: "10/24", cardType: "Discover"),
            MockDTOCard(cardId: 2, cardUId: "UID2", cardNumber: "3456789012345678", cardExpiryDate: "10/24", cardType: "Visa")
        ]
        await loadCards(cards: cards, savedCards: [])
        
        // Act
        viewModel.sortOption = .byType
        
        // Assert
        if case .loaded(let allCards) = viewModel.state {
            XCTAssertEqual(allCards.cards.first?.cardType, "Discover")
            XCTAssertEqual(allCards.cards.last?.cardType, "Visa")
        } else {
            XCTFail("State did not contain loaded cards")
        }
    }
    
    func testSortCardsByCardId() async {
        // Arrange
        let cards = [
            MockDTOCard(cardId: 1, cardUId: "UID1", cardNumber: "3456789012345678", cardExpiryDate: "10/24", cardType: "Discover"),
            MockDTOCard(cardId: 2, cardUId: "UID2", cardNumber: "3456789012345678", cardExpiryDate: "10/24", cardType: "Visa")
        ]
        await loadCards(cards: cards, savedCards: [])
        
        // Act
        viewModel.sortOption = .defaultSort
        
        // Assert
        if case .loaded(let allCards) = viewModel.state {
            XCTAssertEqual(allCards.cards.first?.cardId, 1)
            XCTAssertEqual(allCards.cards.last?.cardId, 2)
        } else {
            XCTFail("State did not contain loaded cards")
        }
    }
}

// Mock classes
class MockCardsUseCase: CardsUseCaseProtocol {
    var mockCards: [DTOCard] = []
    var mockSavedCards: [DTOCard] = []
    var mockError: Error?
    
    func getCards() async throws -> [DTOCard] {
        if let error = mockError { throw error }
        return mockCards
    }
    
    func saveCard(card: DTOCard) async throws {
        if let error = mockError { throw error }
        mockSavedCards.append(card)
    }
    
    func deleteCard(cardId: Int) async throws {
        if let error = mockError { throw error }
        mockSavedCards.removeAll { $0.cardId == cardId }
    }
    
    func getSavedCards() async throws -> [DTOCard] {
        if let error = mockError { throw error }
        return mockSavedCards
    }
}

struct MockDTOCard: DTOCard, Equatable {
    var cardId: Int
    var cardUId: String
    var cardNumber: String
    var cardExpiryDate: String
    var cardType: String
    
    init(cardId: Int, cardUId: String, cardNumber: String, cardExpiryDate: String, cardType: String) {
        self.cardId = cardId
        self.cardUId = cardUId
        self.cardNumber = cardNumber
        self.cardExpiryDate = cardExpiryDate
        self.cardType = cardType
    }
    
    static func == (lhs: MockDTOCard, rhs: MockDTOCard) -> Bool {
            return lhs.cardId == rhs.cardId &&
                   lhs.cardUId == rhs.cardUId &&
                   lhs.cardNumber == rhs.cardNumber &&
                   lhs.cardExpiryDate == rhs.cardExpiryDate &&
                   lhs.cardType == rhs.cardType
        }
}

