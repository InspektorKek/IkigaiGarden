import AVFoundation

final class MusicPlayer: NSObject {
    enum LoopingType: Int {
        case infinite = -1
        case one
    }
    
    static let shared = MusicPlayer()
    private var audioPlayer: AVAudioPlayer?
    private var completionHandler: (() -> Void)?
    
    private var fadeOutTimer: Timer?
    private var fadeInTimer: Timer?
    private let fadeStep: Float = 0.05
    private let fadeInterval: TimeInterval = 0.1
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    private override init() {
        super.init()
    }
    
    func startBackgroundMusic(withFileName fileName: String, loopingType: LoopingType, fileType: String = "mp3", onAudioCompleted: (() -> Void)? = nil) {
        if isPlaying {
            stopBackgroundMusic {
                self.playMusic(fileName: fileName, loopingType: loopingType, fileType: fileType, onAudioCompleted: onAudioCompleted)
            }
        } else {
            playMusic(fileName: fileName, loopingType: loopingType, fileType: fileType, onAudioCompleted: onAudioCompleted)
        }
    }
    
    private func playMusic(fileName: String, loopingType: LoopingType, fileType: String, onAudioCompleted: (() -> Void)? = nil) {
        guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            print("Music file not found: \(fileName).\(fileType)")
            return
        }
        
        let backgroundMusicURL = URL(fileURLWithPath: bundlePath)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.numberOfLoops = loopingType.rawValue
            audioPlayer?.setVolume(0, fadeDuration: 0)
            audioPlayer?.play()
            fadeInTimer = Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { [weak self] _ in
                self?.fadeInVolume(completion: onAudioCompleted)
            }
        } catch {
            print("Could not play music file: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic(completion: (() -> Void)? = nil) {
        fadeOutTimer?.invalidate()
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.fadeOutVolume(completion: completion)
        }
    }
    
    private func fadeInVolume(completion: (() -> Void)? = nil) {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.volume < 0.1 {
            audioPlayer.volume += fadeStep
        } else {
            fadeInTimer?.invalidate()
            completion?()
        }
    }
    
    private func fadeOutVolume(completion: (() -> Void)? = nil) {
        guard let audioPlayer = audioPlayer else { return }
        
        let fadeOutSteps = 6
        let fadeStep = 1.0 / Float(fadeOutSteps)
        
        if audioPlayer.volume > 0.0 {
            audioPlayer.volume -= fadeStep
        } else {
            fadeOutTimer?.invalidate()
            audioPlayer.stop()
            try? AVAudioSession.sharedInstance().setActive(false)
            completion?()
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension MusicPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            completionHandler?()
        }
    }
}
