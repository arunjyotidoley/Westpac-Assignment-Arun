//
//  CardsUseCase.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

final class CardsUseCase: CardsUseCaseProtocol {
    
    let service: CardsServiceProtocol
    let repository: SavedCardsRepositoryProtocol
    
    init(service: CardsServiceProtocol = CardsService(), repository: SavedCardsRepositoryProtocol = SavedCardsRepository()) {
        self.service = service
        self.repository = repository
    }
    
    func getCards() async throws -> [DTOCard] {
        do {
            let cards = try await service.getCards()
            return cards.map{ BOCard(cardId: $0.id,
                                     cardUId: $0.uid,
                                     cardNumber: $0.credit_card_number,
                                     cardExpiryDate: $0.credit_card_expiry_date,
                                     cardType: $0.credit_card_type)}
        } catch let error {
            if let error = error as? RestClientError {
                throw FeatureError(statusCode: error.statusCode, description: "Unable to fetch cards.")
            } else {
                throw FeatureError(statusCode: 500, description: "Unable to fetch cards.")
            }
        }
    }
    
    func saveCard(card: DTOCard) async throws {
        do {
            let card = DLCard(id: card.cardId,
                              uid: card.cardUId,
                              credit_card_number: card.cardNumber,
                              credit_card_expiry_date: card.cardExpiryDate,
                              credit_card_type: card.cardType)
            try repository.save(card: card)
        } catch {
            throw FeatureError(statusCode: 500, description: "Unable to save card.")
        }
    }
    
    func deleteCard(cardId: Int) async throws {
        do {
            try repository.remove(cardId: cardId)
        } catch {
            throw FeatureError(statusCode: 500, description: "Unable to remove card.")
        }
    }
    
    func getSavedCards() async throws -> [DTOCard] {
        do {
            return try repository.getSavedCards().map { BOCard(cardId: $0.id,
                                                                           cardUId: $0.uid,
                                                                           cardNumber: $0.credit_card_number,
                                                                           cardExpiryDate: $0.credit_card_expiry_date,
                                                                           cardType: $0.credit_card_type)}
        } catch {
            throw FeatureError(statusCode: 500, description: "Unable to fetch saved cards.")
        }
    }
    
}
