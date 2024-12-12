//
//  RestClient.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//
import Foundation

struct RestClient: RestClientProtocol {
    
    let endpoint: EndpointProtocol
    private let session: URLSession

    init(endpoint: EndpointProtocol, session: URLSession = .shared) {
        self.endpoint = endpoint
        self.session = session
    }
    
    func execute<Response: Decodable>() async throws -> Response {
        try await executeRequest()
    }
    
    private func executeRequest<Response: Decodable>() async throws -> Response {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        switch endpoint.contentType {
        case .json:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        }
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw RestClientError(statusCode: httpResponse.statusCode, description: "Invalid response from server")
        }
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw RestClientError(statusCode: 0, description: "Failed to decode response: \(error.localizedDescription)")
        }
    }
    
}
