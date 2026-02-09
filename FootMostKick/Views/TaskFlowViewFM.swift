import SwiftUI

struct TaskFlowViewFM: View {
    let task: TaskFM
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            NavigationView {
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
                        
                        Text("Training Steps")
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
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            Text(task.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            
                            Text(task.description)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            ForEach(Array(task.steps.enumerated()), id: \.element.id) { index, step in
                                NavigationLink(destination: TaskStepsViewFM(step: step, taskId: task.id, totalSteps: task.steps.count, currentStepIndex: index).navigationBarHidden(true)) {
                                    AppCardFM {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                Circle()
                                                    .fill(viewModel.currentTheme.accentColor.opacity(0.2))
                                                    .frame(width: 40, height: 40)
                                                
                                                Text("\(index + 1)")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(viewModel.currentTheme.accentColor)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(step.title)
                                                    .font(.system(size: 18, weight: .semibold))
                                                    .foregroundColor(.white)
                                                
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .font(.system(size: 12))
                                                    Text("\(step.time) sec")
                                                        .font(.system(size: 14))
                                                }
                                                .foregroundColor(.white.opacity(0.6))
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white.opacity(0.4))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    
                    // Finish Button (Pinned)
                    VStack {
                        NavigationLink(destination: TaskFinishViewFM(taskId: task.id).navigationBarHidden(true)) {
                            Text("Finish Workout")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.currentTheme.accentColor)
                                .cornerRadius(16)
                        }
                    }
                    .padding(20)
                    .background(viewModel.currentTheme.backgroundColor.ignoresSafeArea(edges: .bottom))
                }
                .navigationBarHidden(true)
                .background(viewModel.currentTheme.backgroundColor.ignoresSafeArea())
            }
        }
        .onAppear { viewModel.showTabBar = false }
        .onChange(of: viewModel.justCompletedTask) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
