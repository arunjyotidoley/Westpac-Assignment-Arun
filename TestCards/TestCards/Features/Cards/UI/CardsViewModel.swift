//
//  CardsViewModel.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//
import SwiftUI

@MainActor
final class CardsViewModel: LoadableObject {
    
    @Published var state: LoadingState<UIOAllCards> = .idle
    @Published var selectedCardCategory: CardCategory = .allCards
    @Published var sortOption: SortOption = .defaultSort {
        didSet {
            applySort()
        }
    }
    private var cards: [UIOCard] = []
    private var savedCards: [UIOCard] = []
    private let cardsUseCase: CardsUseCaseProtocol
    
    init(cardsUseCase: CardsUseCaseProtocol = CardsUseCase()) {
        self.cardsUseCase = cardsUseCase
    }
    
    func load() async {
        if state == .idle {
            state = .loading
        }
        do {
            let loadedCards = try await cardsUseCase.getCards().map{ UIOCard(dto: $0) }
            let loadedSavedCards = try await cardsUseCase.getSavedCards().map{ UIOCard(dto: $0) }
            updateCards(loadedCards, savedCards: loadedSavedCards)
        } catch {
            handle(error: error, defaultMessage: "Loading error. Please try again later")
        }
    }
    
    func saveCard(_ card: UIOCard) async {
        do {
            try await cardsUseCase.saveCard(card: card)
            let updatedSavedCards = try await cardsUseCase.getSavedCards().map{ UIOCard(dto: $0) }
            updateCards(cards, savedCards: updatedSavedCards)
        } catch {
            handle(error: error, defaultMessage: "Saving error. Please try again later")
        }
    }
    
    func removeCard(_ card: UIOCard) async {
        do {
            try await cardsUseCase.deleteCard(cardId: card.cardId)
            let updatedSavedCards = try await cardsUseCase.getSavedCards().map{ UIOCard(dto: $0) }
            updateCards(cards, savedCards: updatedSavedCards)
        } catch {
            handle(error: error, defaultMessage: "Saving error. Please try again later")
        }
    }
    
    func isSaved(_ card: UIOCard) -> Bool {
        savedCards.contains { $0.cardId == card.cardId }
    }
    
    // MARK: - Private Helpers
    private func updateCards(_ newCards: [UIOCard], savedCards newSavedCards: [UIOCard]) {
        cards = sortedCards(newCards)
        savedCards = sortedCards(newSavedCards)
        state = .loaded(UIOAllCards(cards: cards, savedCards: savedCards))
    }
    
    private func applySort() {
        updateCards(cards, savedCards: savedCards)
    }
    
    private func sortedCards(_ cards: [UIOCard]) -> [UIOCard] {
        cards.sorted {
            if sortOption == .byType {
                return $0.cardType == $1.cardType ? $0.cardId < $1.cardId : $0.cardType < $1.cardType
            }
            return $0.cardId < $1.cardId
        }
    }
    
    private func handle(error: Error, defaultMessage: String) {
        if let featureError = error as? FeatureError {
            state = .failed(featureError)
        } else {
            state = .failed(FeatureError(statusCode: 500, description: defaultMessage))
        }
    }
}
