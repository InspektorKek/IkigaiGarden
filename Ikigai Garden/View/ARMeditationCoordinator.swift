import ARKit
import Combine
import RealityKit

class ARMeditationCoordinator: NSObject {
    var arView: ARView?
    
    private var subscriptions: [AnyCancellable] = []
    
    private func bindAnimation(to anchor: AnchorEntity) {
        arView?.scene.subscribe(to: SceneEvents.DidAddEntity.self) { _ in
            if anchor.isActive {
                for entity in anchor.children {
                    for animation in entity.availableAnimations {
                        entity.playAnimation(animation.repeat())
                    }
                }
            }
        }.store(in: &subscriptions)
    }
}

extension ARMeditationCoordinator: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let arView = self.arView else { return }
        
        for anchor in anchors {
            if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .horizontal {
                let entity = try? Entity.load(named: AppConstants.meditationSceneName)
                let anchorEntity = AnchorEntity(world: planeAnchor.transform)
                if let entity = entity {
                    anchorEntity.addChild(entity)
                    
                    arView.scene.addAnchor(anchorEntity)
                    bindAnimation(to: anchorEntity)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        MusicPlayer.shared.startBackgroundMusic(withFileName: "meditation", loopingType: .one)
                    }
                    
                    if let configuration = session.configuration as? ARWorldTrackingConfiguration {
                        configuration.planeDetection = []
                        session.run(configuration)
                    }
                    
                    break
                }
            }
        }
    }
}

extension ARMeditationCoordinator: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Coaching overlay deactivated.")
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Coaching overlay will activate.")
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Session reset requested.")
    }
}
