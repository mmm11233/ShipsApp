//
//  File.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import SwiftUI

// MARK: - ViewDidLoadModifier
struct ViewDidLoadModifier: ViewModifier {
    private let action: () async -> Void
    @State private var hasAppeared = false
    
    init(_ action: @escaping () async -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}

// MARK: - View extension for easier usage
extension View {
    func onViewDidLoad(_ action: @escaping () async -> Void) -> some View {
        modifier(ViewDidLoadModifier(action))
    }
}
