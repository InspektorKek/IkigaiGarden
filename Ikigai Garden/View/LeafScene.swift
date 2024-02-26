import SpriteKit

final class LeafScene: SKScene, ObservableObject {
    private var leafEmitter: SKEmitterNode?
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = .clear
        
        setupLeafEmitter()
    }
    
    private func setupLeafEmitter() {
        size = UIScreen.main.bounds.size
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 1, y: 1)
        
        if let node = SKEmitterNode(fileNamed: "SakuraLeaf") {
            leafEmitter = node
            addChild(node)
            node.particlePositionRange.dx = UIScreen.main.bounds.width
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        guard let windowScene = view?.window?.windowScene else { return }
        size = windowScene.screen.bounds.size
        leafEmitter?.particlePositionRange.dx = windowScene.screen.bounds.width
        leafEmitter?.position = CGPoint(x: size.width, y: size.height)
    }
}
