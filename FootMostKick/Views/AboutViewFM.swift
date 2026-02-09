import SwiftUI

struct AboutViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("About")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.clear)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(viewModel.currentTheme.primaryColor.ignoresSafeArea(edges: .top))
                
                Spacer()
                
                VStack(spacing: 24) {
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                    
                    Text("FootMost Kick")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Version 1.0.0")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Your ultimate guide to mastering football techniques. From basic kicks to advanced strategies.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
        }
    }

#Preview {
    AboutViewFM()
        .environmentObject(MainViewModelFM())
}
