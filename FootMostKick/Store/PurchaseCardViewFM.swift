import SwiftUI

struct PurchaseCardViewFM: View {
    let title: String
    let price: String
    let description: String
    let isLocked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            HStack {
                Spacer()
                Text(price)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isLocked ? Color.white.opacity(0.2) : Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}
