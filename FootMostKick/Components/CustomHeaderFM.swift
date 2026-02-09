import SwiftUI

struct CustomHeaderFM: View {
    let title: String
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            NavigationLink(destination: SettingsViewFM().navigationBarHidden(true)) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20) // Unified vertical padding
        .background(
            viewModel.currentTheme.primaryColor
                .ignoresSafeArea(edges: .top)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 5)
        )
    }
}

#Preview {
    VStack {
        CustomHeaderFM(title: "FootMost Kick")
        Spacer()
    }
    .background(Color.blue)
    .environmentObject(MainViewModelFM())
    .ignoresSafeArea()
}
