//
//  ActivityIndicatorView.swift
//  TestCards
//
//  Created by Arun Doley on 12/12/2024.
//

import SwiftUI

struct ActivityIndicatorView: View {
    
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 10)
        }
    }
}
