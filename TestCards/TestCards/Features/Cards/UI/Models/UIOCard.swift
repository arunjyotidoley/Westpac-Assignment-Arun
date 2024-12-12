//
//  DTOCard+Equatable.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

struct UIOCard: DTOCard, Equatable, Hashable {
    let cardId: Int
    let cardUId: String
    let cardNumber: String
    let cardExpiryDate: String
    let cardType: String
    
    init(dto: DTOCard) {
        self.cardId = dto.cardId
        self.cardUId = dto.cardUId
        self.cardNumber = dto.cardNumber
        self.cardExpiryDate = dto.cardExpiryDate
        self.cardType = dto.cardType
    }
    
    static func == (lhs: UIOCard, rhs: UIOCard) -> Bool {
        return lhs.cardId == rhs.cardId &&
        lhs.cardUId == rhs.cardUId &&
        lhs.cardNumber == rhs.cardNumber &&
        lhs.cardExpiryDate == rhs.cardExpiryDate &&
        lhs.cardType == rhs.cardType
    }
    
}


