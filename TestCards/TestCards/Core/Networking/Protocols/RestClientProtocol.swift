//
//  RestClientProtocol.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

protocol RestClientProtocol {
    
    var endpoint: EndpointProtocol { get }
    func execute<Response: Decodable>() async throws -> Response

}
