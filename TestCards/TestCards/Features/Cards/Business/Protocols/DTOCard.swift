//
//  DTOCard.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//


protocol DTOCard {
    var cardId: Int { get }
    var cardUId: String { get }
    var cardNumber: String { get }
    var cardExpiryDate: String { get }
    var cardType: String { get }
}