import SwiftUI

struct VolumeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            let offset: CGFloat = 5
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.pink)
                .brightness(-0.2)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.pink)
                .offset(y: configuration.isPressed ? offset : 0)
            
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
        .compositingGroup()
        .shadow(radius: 6, y: 4)
    }
}
