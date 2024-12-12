//
//  LoadingState.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

enum LoadingState<Value>: Equatable where Value: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(FeatureError)

    static func ==(lhs: LoadingState<Value>, rhs: LoadingState<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lhsValue), .loaded(let rhsValue)):
            return lhsValue == rhsValue
        case (.failed(let lhsError), .failed(let rhsError)):
            return lhsError.statusCode == rhsError.statusCode && lhsError.description == rhsError.description
        default:
            return false
        }
    }
}
