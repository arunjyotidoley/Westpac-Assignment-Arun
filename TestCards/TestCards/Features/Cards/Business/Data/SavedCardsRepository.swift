//
//  SavedCardsRepository.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

protocol SavedCardsRepositoryProtocol {
    func save(card: DLCard) throws
    func remove(cardId: Int) throws
    func getSavedCards() throws -> [DLCard]
}

final class SavedCardsRepository: SavedCardsRepositoryProtocol {
    
    let storage: MemoryStorageProtocol
    
    init(storage: MemoryStorageProtocol = CoreFacade().memoryStorage) {
        self.storage = storage
    }
    
    func save(card: DLCard) throws {
        if let cardStore: DLCardStore = try storage.retrieve(forKey: key) {
            if !cardStore.cards.contains(where: { $0.id == card.id }) {
                var savedCards = cardStore.cards
                savedCards.append(card)
                try storage.save(DLCardStore(cards: savedCards), forKey: key)
            }
        } else {
            try storage.save(DLCardStore(cards: [card]), forKey: key)
        }
    }
    
    func remove(cardId: Int) throws {
        if let cardStore: DLCardStore = try storage.retrieve(forKey: key) {
            var savedCards = cardStore.cards
            savedCards.removeAll(where: { $0.id == cardId })
            try storage.save(DLCardStore(cards: savedCards), forKey: key)
        }
    }
    
    func getSavedCards() throws -> [DLCard] {
        if let cardStore: DLCardStore = try storage.retrieve(forKey: key) {
            return cardStore.cards
        } else {
            return []
        }
    }
    
    private var key: String  = "savedCards"
    
}
