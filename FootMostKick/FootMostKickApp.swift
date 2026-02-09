import SwiftUI

@main
struct FootMostKickApp: App {
    @StateObject private var viewModel = MainViewModelFM()
    
    var body: some Scene {
        WindowGroup {
            MainViewFM()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark) // Force dark mode for now as per design
        }
    }
}
