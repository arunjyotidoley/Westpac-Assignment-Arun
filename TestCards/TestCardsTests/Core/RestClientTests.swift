//
//  RestClientTests.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import XCTest
@testable import TestCards

final class RestClientTests: XCTestCase {
    private var mockEndpoint: MockEndpoint!
    private var restClient: RestClient!
    
    override func setUp() {
        super.setUp()
        mockEndpoint = MockEndpoint(url: URL(string: "https://example.com")!,
                                    method: .get,
                                    contentType: .json)
        restClient = RestClient(endpoint: mockEndpoint)
    }
    
    override func tearDown() {
        mockEndpoint = nil
        restClient = nil
        super.tearDown()
    }
    
    func testExecuteSuccess() async throws {
        let expectedResponse = TestResponse(message: "Success")
        let responseData = try JSONEncoder().encode(expectedResponse)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, self.mockEndpoint.url)
            XCTAssertEqual(request.httpMethod, self.mockEndpoint.method.rawValue)
            return (HTTPURLResponse(url: self.mockEndpoint.url,
                                    statusCode: 200,
                                    httpVersion: nil,
                                    headerFields: nil)!,
                    responseData)
        }
        
        let client = makeRestClient()
        let response: TestResponse = try await client.execute()
        XCTAssertEqual(response.message, expectedResponse.message)
    }
    
    func testExecuteServerError() async throws {
        MockURLProtocol.requestHandler = { _ in
            return (
                HTTPURLResponse(url: self.mockEndpoint.url,
                                statusCode: 500,
                                httpVersion: nil,
                                headerFields: nil)!,
                Data()
            )
        }
        
        let client = makeRestClient()
        
        do {
            _ = try await client.execute() as TestResponse
            XCTFail("Expected error, but no error was thrown")
        } catch {
            if let restClientError = error as? RestClientError {
                XCTAssertEqual(restClientError.statusCode, 500)
                XCTAssertEqual(restClientError.description, "Invalid response from server")
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
    
    func testExecuteDecodingFailure() async throws {
        let invalidData = "Invalid JSON".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { _ in
            return (
                HTTPURLResponse(url: self.mockEndpoint.url,
                                statusCode: 200,
                                httpVersion: nil,
                                headerFields: nil)!,
                invalidData
            )
        }
        
        let client = makeRestClient()
        
        do {
            _ = try await client.execute() as TestResponse
            XCTFail("Expected error, but no error was thrown")
        } catch {
            if let restClientError = error as? RestClientError {
                XCTAssertEqual(restClientError.statusCode, 0)
                XCTAssertTrue(restClientError.description.contains("Failed to decode response"))
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
    
    private func makeRestClient() -> RestClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return RestClient(endpoint: mockEndpoint, session: session)
    }
}

// Supporting Mock Classes
struct TestResponse: Codable {
    let message: String
}

final class MockEndpoint: EndpointProtocol {
    var url: URL
    var method: HTTPMethod
    var contentType: ContentType
    
    init(url: URL, method: HTTPMethod, contentType: ContentType) {
        self.url = url
        self.method = method
        self.contentType = contentType
    }
}

final class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is not set.")
        }
        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
