import SwiftUI

struct ShotDetailViewFM: View {
    @EnvironmentObject var viewModel: MainViewModelFM
    @Environment(\.presentationMode) var presentationMode
    
    let selectedShotName: String
    
    // Expanded data structure for shots
    private var shotData: (name: String, icon: String, desc: String, tactical: String, mistake: String, insight: String, tips: [String]) {
        let allShots = [
            (name: "Knuckleball", icon: "wind", 
             desc: "A shot with no spin that moves unpredictably in the air.",
             tactical: "Best for direct free kicks from 25-35 yards out where you want to surprise the keeper.",
             mistake: "Leaning too far back or striking with the side of the foot will create unwanted spin.",
             insight: "Lock your ankle so hard it feels like a piece of iron. The zero-spin is psychological warfare.",
             tips: ["Hit the center/valve exactly", "Minimal follow-through", "High-velocity approach"]),
            
            (name: "Curved", icon: "arrow.uturn.right", 
             desc: "A shot that bends around defenders and keepers using the inside of the foot.",
             tactical: "Use when you need to bypass a wall or a keeper positioned at the near post.",
             mistake: "Failing to 'brush' the ball; if you hit it too flat, it won't curve.",
             insight: "Imagine your foot is a paint brush, and the ball is a canvas you're wrapping blue paint around.",
             tips: ["Wide approach angle", "Inside of foot contact", "Sweep through across body"]),
            
            (name: "Power", icon: "bolt.fill", 
             desc: "A strike purely focused on speed and force using the laces (instep).",
             tactical: "Most effective when running onto a loose ball or for mid-range ground strikes.",
             mistake: "Landing on your plant foot instead of your kicking foot often kills the momentum.",
             insight: "The power doesn't come from your leg, it comes from your core and the snap of your knee.",
             tips: ["Toes pointed down", "Body over the ball", "Land on your kicking foot"]),
            
            (name: "Chip", icon: "arrow.up.right", 
             desc: "A delicate lofted shot to beat a rushing keeper in a 1-on-1 situation.",
             tactical: "Wait until the keeper drops their knees or fully commits to diving.",
             mistake: "Doing a full swing; a chip is a stabbing motion with 'backspin' intent.",
             insight: "Look at the keeper's feet, not their hands. Once they plant, they are vulnerable to the lob.",
             tips: ["Stab the bottom of the ball", "No follow-through", "Eyes on the keeper's position"]),
            
            (name: "Volley", icon: "figure.soccer", 
             desc: "Striking the ball while it's in mid-air, often the most spectacular shot.",
             tactical: "Perfect for finishing crosses or clearances that drop at the edge of the box.",
             mistake: "Eyes off the ball at the last second or trying to hit it too hard.",
             insight: "The ball's existing momentum is your friend. You just need to direct it with a clean surface.",
             tips: ["Tracking with your chin", "Knee over the ball", "Side-on body orientation"])
        ]
        
        return allShots.first(where: { $0.name == selectedShotName }) ?? allShots[0]
    }
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        heroSection
                        
                        detailBlock(title: "When to Use", content: shotData.tactical, icon: "target")
                        
                        detailBlock(title: "Common Mistake", content: shotData.mistake, icon: "exclamationmark.triangle", color: .red.opacity(0.8))
                        
                        detailBlock(title: "Pro Insight", content: shotData.insight, icon: "lightbulb.fill", color: .yellow.opacity(0.8))
                        
                        tipsSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.showTabBar = false }
        .onDisappear { viewModel.showTabBar = true }
    }
    
    private var header: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(shotData.name)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Symmetrical spacer
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.clear)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(viewModel.currentTheme.primaryColor.ignoresSafeArea(edges: .top))
    }
    
    private var heroSection: some View {
        AppCardFM {
            VStack(spacing: 16) {
                Image(systemName: shotData.icon)
                    .font(.system(size: 60))
                    .foregroundColor(viewModel.currentTheme.accentColor)
                    .padding(20)
                    .background(Circle().fill(Color.white.opacity(0.1)))
                
                Text(shotData.desc)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func detailBlock(title: String, content: String, icon: String, color: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color ?? viewModel.currentTheme.accentColor)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.system(size: 15))
                .lineSpacing(4)
                .foregroundColor(.white.opacity(0.9))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(viewModel.currentTheme.cardBackground)
                .cornerRadius(12)
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Execution Checklist")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(shotData.tips, id: \.self) { tip in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(tip)
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    ShotDetailViewFM(selectedShotName: "Knuckleball")
        .environmentObject(MainViewModelFM())
}
