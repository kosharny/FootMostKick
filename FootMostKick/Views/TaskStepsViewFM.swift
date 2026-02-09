import SwiftUI

struct TaskStepsViewFM: View {
    let step: TaskStepFM
    let taskId: String
    let totalSteps: Int
    let currentStepIndex: Int
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var isActive = false
    @State private var progress: CGFloat = 1.0
    
    init(step: TaskStepFM, taskId: String, totalSteps: Int, currentStepIndex: Int) {
        self.step = step
        self.taskId = taskId
        self.totalSteps = totalSteps
        self.currentStepIndex = currentStepIndex
        _timeRemaining = State(initialValue: step.time)
    }
    
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
                    
                    Text("Step \(currentStepIndex + 1)/\(totalSteps)")
                        .font(.system(size: 18, weight: .bold))
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Title and Description
                        VStack(spacing: 12) {
                            Text(step.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(step.instruction)
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Timer View
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 15)
                                .opacity(0.3)
                                .foregroundColor(.white)
                            
                            Circle()
                                .trim(from: 0.0, to: progress)
                                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                                .foregroundColor(viewModel.currentTheme.accentColor)
                                .rotationEffect(Angle(degrees: 270.0))
                                .animation(.linear(duration: 1.0), value: progress)
                            
                            // Soccer Ball Animation (Moving along the path)
                            // We need to calculate position based on progress
                            // GeometryReader for Ball Position
                            GeometryReader { geometry in
                                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                                let radius = geometry.size.width / 2 // Corrected radius
                                
                                Image(systemName: "soccerball")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(viewModel.currentTheme.accentColor))
                                    .clipShape(Circle())
                                    .modifier(CircularPositionModifier(progress: progress, radius: radius, center: center))
                                    .animation(.linear(duration: 1.0), value: progress) // Ensure animation matches trim
                                    .shadow(radius: 5)
                            }
                            
                            VStack(spacing: 5) {
                                Text("\(timeFormatted(timeRemaining))")
                                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                
                                Text("Remaining")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .frame(width: 250, height: 250)
                        .padding(.vertical, 20)
                        
                        // Controls
                        HStack(spacing: 30) {
                            Button(action: {
                                isActive.toggle()
                                if isActive {
                                    startTimer()
                                } else {
                                    stopTimer()
                                }
                            }) {
                                Image(systemName: isActive ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: {
                                stopTimer()
                                timeRemaining = step.time
                                progress = 1.0
                                isActive = false
                            }) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .onAppear {
                viewModel.showTabBar = false
            }
            .onDisappear {
                stopTimer()
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                withAnimation {
                    progress = CGFloat(timeRemaining) / CGFloat(step.time)
                }
            } else {
                stopTimer()
                isActive = false
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
