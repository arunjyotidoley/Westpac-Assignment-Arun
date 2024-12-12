//
//  CardsUseCaseProtocol.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//


protocol CardsUseCaseProtocol {
    func getCards() async throws -> [DTOCard]
    func saveCard(card: DTOCard) async throws
    func deleteCard(cardId: Int) async throws
    func getSavedCards() async throws -> [DTOCard]
}
