//
//  MakeWholeViewTapable.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import SwiftUI

struct MakeWholeViewTapable: ViewModifier {
    init() {}
 
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle()) 
    }
}

extension View {
    func makeWholeViewTapable() -> some View {
        self.modifier(MakeWholeViewTapable())
    }
}
