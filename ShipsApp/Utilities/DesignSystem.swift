//
//  DesignSystem.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import SwiftUI

enum DS {
    
    enum Colors {
        static let accent = Color.blue
        static let success = Color.green
        static let danger = Color.red
        static let background = Color(.systemGroupedBackground)
        static let placeholder = Color.gray.opacity(0.3)
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
    }
    
    enum Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    enum Typography {
        static func heading(_ size: CGFloat = 24) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        
        static func subheading(_ size: CGFloat = 18) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        static var body: Font { .system(.body, design: .rounded) }
    }
}
