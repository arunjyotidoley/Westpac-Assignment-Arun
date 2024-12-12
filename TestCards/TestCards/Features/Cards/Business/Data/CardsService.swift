//
//  CardsService.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

protocol CardsServiceProtocol {
    func getCards() async throws -> [DLCard]
}

struct CardsService: CardsServiceProtocol {
    
    let restClient: RestClientProtocol
    
    init(restClient: RestClientProtocol = CoreFacade().restClient(endpoint: GetCardsEndpoint())) {
        self.restClient = restClient
    }

    func getCards() async throws -> [DLCard] {
        return try await restClient.execute()
    }
    
}
