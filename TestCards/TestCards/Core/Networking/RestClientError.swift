//
//  RestClientError.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

struct RestClientError: Error {
    let statusCode: Int
    let description: String
    
    init(statusCode: Int, description: String) {
        self.statusCode = statusCode
        self.description = description
    }
}
