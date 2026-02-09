import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    @EnvironmentObject var viewModel: MainViewModelFM
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.3)
                .foregroundColor(.white)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(viewModel.currentTheme.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.7)
        .frame(width: 50, height: 50)
        .padding()
        .background(Color.blue)
        .environmentObject(MainViewModelFM())
}
