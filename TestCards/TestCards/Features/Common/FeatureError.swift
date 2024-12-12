//
//  FeatureError.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

struct FeatureError: Error {
    
    let statusCode: Int
    let description: String
    
    init(statusCode: Int, description: String) {
        self.statusCode = statusCode
        self.description = description
    }
    
}
