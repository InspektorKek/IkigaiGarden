import SceneKit
import SpriteKit
import SwiftUI

struct MenuView: View {
    @AppStorage(AppConstants.isOnboardingShownKey) private var isOnboardingShown: Bool = false
    @State private var showARMeditationView: Bool = false
    @State private var onOnboardingFinished: Bool = false
    
    @State private var animationProgress: CGFloat = 0.0
    @State private var isOnboardingNextStepAvailable: Bool = false
    @State private var shouldShowStartMeditationStep: Bool = false
    
    @State private var onboardingStep: OnboardingStep = .welcomeText
    
    @Orientation private var orientation
    
    var body: some View {
        ZStack {
            SceneView(
                scene: SCNScene(named: "MainMenuBackground.scn")!
            )
            .edgesIgnoringSafeArea(.all)
            
            SpriteView(
                scene: LeafScene(),
                options: [.allowsTransparency]
            )
            .edgesIgnoringSafeArea(.all)
            
            if isOnboardingShown || onOnboardingFinished {
                VStack(alignment: .leading) {
                    title
                        .multilineTextAlignment(.leading)
                    Spacer()
                    startButton
                }
                .padding(20)
            } else {
                VStack {
                    VStack(alignment: .leading) {
                        if orientation.isPortrait || UIDevice.current.userInterfaceIdiom == .pad {
                            title
                            Spacer()
                            onboardingDescription
                        } else {
                            HStack {
                                onboardingDescription
                                Spacer()
                                title
                            }
                        }
                    }
                    
                    switch onboardingStep {
                    case .welcomeText:
                        Text("Tap to continue")
                            .foregroundColor(.pink)
                            .karashaFont()
                            .opacity(isOnboardingNextStepAvailable ? 1 : 0)
                    case .finalText:
                        Text("Tap to continue")
                            .foregroundColor(.pink)
                            .karashaFont()
                            .opacity(shouldShowStartMeditationStep ? 1 : 0)
                    }
                }
                .padding(20)
                .onTapGesture {
                    switch onboardingStep {
                    case .welcomeText:
                        onboardingStep = .finalText
                    case .finalText:
                        onOnboardingFinished = true
                        isOnboardingShown = true
                    }
                }
            }
        }
        .onAppear {
            MusicPlayer.shared.startBackgroundMusic(withFileName: "background_music_main", loopingType: .infinite)
        }
    }
    
    private var title: some View {
        Group {
            Text("Welcome\nto\n")
                .font(.custom(karashaFontName, size: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30))
                .foregroundColor(.white) +
            Text("Ikigai\nGarden")
                .font(.custom(karashaFontName, size: UIDevice.current.userInterfaceIdiom == .pad ? 100 : 60))
                .foregroundColor(.pink)
        }
        .multilineTextAlignment(.leading)
    }
    
    private var startButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft)
                .impactOccurred()
            withAnimation(.easeInOut) {
                showARMeditationView = true
            }
        } label: {
            Text("Start Meditation")
                .karashaFont()
                .bold()
                .foregroundStyle(.white)
        }
        .buttonStyle(VolumeButtonStyle())
        .frame(height: 44)
        .padding(.horizontal, 40)
        .fullScreenCover(isPresented: $showARMeditationView) {
            ARMeditationView()
        }
    }
    
    private var onboardingDescription: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    Image("ancient_scroll")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, alignment: .center)
                        .mask(
                            HStack {
                                Rectangle()
                                    .frame(width: geometry.size.width * animationProgress)
                                if animationProgress != 1 {
                                    Spacer()
                                }
                            }
                        )
                    
                    if onboardingStep == .welcomeText {
                        TypeWriterView(onboardingStep.description) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.bouncy) {
                                    isOnboardingNextStepAvailable = true
                                }
                            }
                        }
                        .font(.custom(karashaFontName, size: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 17))
                        .foregroundStyle(.black)
                        .frame(width: geometry.size.width * (orientation.isLandscape ? 0.5 : 0.75), height: geometry.size.height * (orientation.isLandscape ? 0.7 : 0.32), alignment: .topLeading)
                    } else {
                        TypeWriterView(onboardingStep.description) {
                            onboardingStep = .finalText
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.bouncy) {
                                    shouldShowStartMeditationStep = true
                                }
                            }
                        }
                        .font(.custom(karashaFontName, size: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 17))
                        .foregroundStyle(.black)
                        .frame(width: geometry.size.width * (orientation.isLandscape ? 0.5 : 0.75), height: geometry.size.height * (orientation.isLandscape ? 0.7 : 0.32), alignment: .topLeading)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    animationProgress = 1.0
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
