import Foundation
import RealityKit

class ARExperience: RealityKit.Entity, RealityKit.HasAnchoring {
    static func load(named resourceName: String) -> ARExperience {
        let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz")!
        let anchor = try! ARExperience.loadAnchor(contentsOf: url)
        return ARExperience(anchor: anchor)
    }

    required init() {
        super.init()
    }

    required init(anchor: RealityKit.AnchorEntity) {
        super.init()
        self.anchoring = anchor.anchoring
        self.addChild(anchor)
    }
}
