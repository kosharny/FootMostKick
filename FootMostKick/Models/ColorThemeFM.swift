import SwiftUI

struct ColorThemeFM {
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let backgroundColor: LinearGradient
    let cardBackground: LinearGradient
}

extension ColorThemeFM {
    static let defaultTheme = ColorThemeFM(
        primaryColor: Color(red: 0.1, green: 0.2, blue: 0.5),
        secondaryColor: .white,
        accentColor: Color(red: 0.3, green: 0.7, blue: 0.9),
        backgroundColor: LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.1, blue: 0.3),
                Color(red: 0.1, green: 0.2, blue: 0.5)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.25, blue: 0.55),
                Color(red: 0.1, green: 0.2, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    static let oceanTheme = ColorThemeFM(
        primaryColor: Color(red: 0.0, green: 0.3, blue: 0.6),
        secondaryColor: .white,
        accentColor: Color(red: 0.2, green: 0.8, blue: 1.0),
        backgroundColor: LinearGradient(
            colors: [
                Color(red: 0.0, green: 0.2, blue: 0.4),
                Color(red: 0.0, green: 0.4, blue: 0.7)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.35, blue: 0.65),
                Color(red: 0.05, green: 0.25, blue: 0.55)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
    
    static let midnightTheme = ColorThemeFM(
        primaryColor: Color(red: 0.15, green: 0.15, blue: 0.35),
        secondaryColor: .white,
        accentColor: Color(red: 0.5, green: 0.6, blue: 1.0),
        backgroundColor: LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.05, blue: 0.15),
                Color(red: 0.15, green: 0.15, blue: 0.35)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.2, blue: 0.4),
                Color(red: 0.15, green: 0.15, blue: 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
