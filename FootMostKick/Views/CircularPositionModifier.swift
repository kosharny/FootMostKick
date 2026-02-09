import SwiftUI

struct CircularPositionModifier: AnimatableModifier {
    var progress: Double
    let radius: CGFloat
    let center: CGPoint
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        
        let angle = Angle(degrees: 270 + (360 * progress))
        let x = center.x + radius * CGFloat(cos(angle.radians))
        let y = center.y + radius * CGFloat(sin(angle.radians))
        
        return content.position(x: x, y: y)
    }
}
