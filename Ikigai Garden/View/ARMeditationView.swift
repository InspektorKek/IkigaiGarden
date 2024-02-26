import SwiftUI
import ARKit
import RealityKit

struct ARMeditationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ARMeditationContainerView()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(VolumeButtonStyle())
                    .frame(width: 44, height: 44)
                }
                
                Spacer()
            }
            .padding()
        }
        .onDisappear {
            MusicPlayer.shared.startBackgroundMusic(withFileName: "background_music_main", loopingType: .infinite)
        }
    }
}

struct ARMeditationContainerView: UIViewRepresentable {
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        arView.environment.lighting.intensityExponent = 1
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.activatesAutomatically = true
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.delegate = context.coordinator
        arView.addSubview(coachingOverlay)
        
        arView.session.run(configuration)
        
        arView.session.delegate = context.coordinator
        context.coordinator.arView = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    func makeCoordinator() -> ARMeditationCoordinator {
        ARMeditationCoordinator()
    }
}

#Preview {
    ARMeditationView()
}
