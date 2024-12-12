//
//  CoreFacade.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

struct CoreFacade {
    
    func restClient(endpoint: EndpointProtocol) -> RestClientProtocol {
        RestClient(endpoint: endpoint)
    }
    
    var memoryStorage: MemoryStorageProtocol { MemoryStorage.shared }
    
}
