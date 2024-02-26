import Combine
import SwiftUI
import UIKit

class OrientationManager: ObservableObject {
    @Published var type: UIDeviceOrientation = .unknown
    
    static let shared = OrientationManager()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene as? UIWindowScene else { return }
        
        let orientation = sceneDelegate.interfaceOrientation
        
        switch orientation {
        case .portrait: type = .portrait
        case .portraitUpsideDown: type = .portraitUpsideDown
        case .landscapeLeft: type = .landscapeLeft
        case .landscapeRight: type = .landscapeRight
            
        default: type = .unknown
        }
        
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink() { [weak self] _ in
                self?.type = UIDevice.current.orientation
            }
            .store(in: &cancellables)
    }
}

@propertyWrapper struct Orientation: DynamicProperty {
    @StateObject private var manager = OrientationManager.shared
    
    var wrappedValue: UIDeviceOrientation {
        manager.type
    }
}
