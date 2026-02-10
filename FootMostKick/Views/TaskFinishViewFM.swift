import SwiftUI

struct TaskFinishViewFM: View {
    let taskId: String
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Trophy / Success Icon
                ZStack {
                    Circle()
                        .fill(viewModel.currentTheme.accentColor.opacity(0.2))
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .fill(viewModel.currentTheme.accentColor.opacity(0.4))
                        .frame(width: 150, height: 150)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 80))
                        .foregroundColor(viewModel.currentTheme.accentColor)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    Text("Task Completed!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Great job! You've improved your skills.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                // Stats / Rewards
                HStack(spacing: 40) {
                    VStack(spacing: 8) {
                        Text("XP Earned")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        Text("+50")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Time")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        Text("Done")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    viewModel.markTaskCompleted(taskId)
                    viewModel.selectedTab = 0
                }) {
                    Text("Back to Training")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.currentTheme.primaryColor)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.showTabBar = false
            // Mark task as completed in Logic?
            // viewModel.completeTask(taskId)
        }
    }
}

#Preview {
    TaskFinishViewFM(taskId: "1")
        .environmentObject(MainViewModelFM())
}
