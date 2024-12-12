//
//  AsyncContentView.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import SwiftUI

struct AsyncContentView<Source: LoadableObject, Content: View>: View {
    
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content

    init(source: Source,
         @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
     }
    
    var body: some View {
        switch source.state {
        case .idle:
            Color.clear.onAppear(perform: {
            })
        case .loading:
            ActivityIndicatorView()
        case .failed(let error):
            Text("\(error.description)")
        case .loaded(let output):
            content(output)
        }
    }
    
}
