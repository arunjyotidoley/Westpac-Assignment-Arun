//
//  EndpointProtocol.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

import Foundation

protocol EndpointProtocol {
    
    var method: HTTPMethod { get }
    var url: URL { get }
    var contentType: ContentType { get }
        
}

enum ContentType: String {
    
    case json 
    
}

enum HTTPMethod: String {
    case get = "GET"
}
