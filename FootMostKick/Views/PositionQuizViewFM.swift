import SwiftUI

struct PositionQuizViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestionIndex = 0
    @State private var answers: [String: Int] = ["Forward": 0, "Midfielder": 0, "Defender": 0, "Goalkeeper": 0]
    @State private var quizCompleted = false
    @State private var finalResult = ""
    
    struct Question {
        let text: String
        let options: [(text: String, position: String)]
    }
    
    private let questions = [
        Question(text: "What do you enjoy most in a match?", options: [
            ("Scoring goals", "Forward"),
            ("Controlling play", "Midfielder"),
            ("Defensive stops", "Defender"),
            ("Saving shots", "Goalkeeper")
        ]),
        Question(text: "What is your strongest physical attribute?", options: [
            ("Speed", "Forward"),
            ("Stamina", "Midfielder"),
            ("Strength", "Defender"),
            ("Reflexes", "Goalkeeper")
        ]),
        Question(text: "How do you prefer to help your team?", options: [
            ("Determined finishing", "Forward"),
            ("Creative assists", "Midfielder"),
            ("Interceptions", "Defender"),
            ("Command of the area", "Goalkeeper")
        ]),
        Question(text: "What's your reaction to an opponent's attack?", options: [
            ("Wait for a counter", "Forward"),
            ("Try to win it back", "Midfielder"),
            ("Form a solid wall", "Defender"),
            ("Be ready to dive", "Goalkeeper")
        ]),
        Question(text: "Where do you feel most comfortable on the pitch?", options: [
            ("Opponent's box", "Forward"),
            ("The center circle", "Midfielder"),
            ("Right in front of goal", "Defender"),
            ("Between the posts", "Goalkeeper")
        ])
    ]
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                if !quizCompleted {
                    quizContent
                } else {
                    resultContent
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.showTabBar = false }
    }
    
    private var header: some View {
        ZStack {
            viewModel.currentTheme.primaryColor
                .ignoresSafeArea(edges: .top)
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Position Finder")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Balance
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
    }
    
    private var quizContent: some View {
        VStack(spacing: 30) {
            // Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(viewModel.currentTheme.accentColor)
                            .frame(width: geo.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count), height: 6)
                            .animation(.spring(), value: currentQuestionIndex)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Text(questions[currentQuestionIndex].text)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .frame(height: 100)
            
            VStack(spacing: 16) {
                ForEach(questions[currentQuestionIndex].options, id: \.text) { option in
                    Button(action: { handleAnswer(option.position) }) {
                        Text(option.text)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.currentTheme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var resultContent: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: positionIcon(finalResult))
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.currentTheme.accentColor)
                    .padding(30)
                    .background(Circle().fill(Color.white.opacity(0.1)))
                
                Text("Your Ideal Position is")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(finalResult)
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.white)
            }
            
            Text(positionDescription(finalResult))
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(6)
            
            Spacer()
            
            Button(action: {
                viewModel.setUserPosition(finalResult)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue to Field")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(viewModel.currentTheme.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(viewModel.currentTheme.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .onDisappear{ viewModel.showTabBar = true }
    }
    
    private func handleAnswer(_ position: String) {
        answers[position, default: 0] += 1
        
        if currentQuestionIndex < questions.count - 1 {
            withAnimation {
                currentQuestionIndex += 1
            }
        } else {
            calculateResult()
        }
    }
    
    private func calculateResult() {
        if let maxPosition = answers.max(by: { $0.value < $1.value })?.key {
            finalResult = maxPosition
        } else {
            finalResult = "Midfielder"
        }
        
        withAnimation {
            quizCompleted = true
        }
    }
    
    private func positionIcon(_ position: String) -> String {
        switch position {
        case "Forward": return "figure.soccer"
        case "Midfielder": return "bolt.fill"
        case "Defender": return "shield.fill"
        case "Goalkeeper": return "hand.raised.fill"
        default: return "person.fill"
        }
    }
    
    private func positionDescription(_ position: String) -> String {
        switch position {
        case "Forward":
            return "You are a clinical finisher with explosive pace. Your goal is to be at the sharp end of the attack and convert chances into goals."
        case "Midfielder":
            return "You are the heart of the team. With exceptional vision and stamina, you control the tempo and bridge defense with attack."
        case "Defender":
            return "You are a rock at the back. Strong, disciplined, and focused, you thrive on stopping the opposition and protecting your goal."
        case "Goalkeeper":
            return "You are the last line of defense. With lightning reflexes and absolute focus, you command your area and make game-winning saves."
        default:
            return "You are a versatile player who can adapt to any role on the pitch."
        }
    }
}

#Preview {
    PositionQuizViewFM()
        .environmentObject(MainViewModelFM())
}
