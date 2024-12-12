//
//  GetCardsEndpoint.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//
import Foundation

struct GetCardsEndpoint: EndpointProtocol {
    let method: HTTPMethod
    let url: URL
    let contentType: ContentType
    
    init () {
        self.method = .get
        self.url = URL(string: "https://random-data-api.com/api/v2/credit_cards?size=100")!
        self.contentType = .json
    }
    
}
