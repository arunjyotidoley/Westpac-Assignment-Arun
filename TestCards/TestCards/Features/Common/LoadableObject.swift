//
//  LoadableObject.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import SwiftUI

@MainActor
protocol Loadable: ObservableObject {
    
    func load() async
    
}

@MainActor
protocol LoadableObject: Loadable where Output: Equatable {
    
    associatedtype Output
    var state: LoadingState<Output> { get }
    
}
