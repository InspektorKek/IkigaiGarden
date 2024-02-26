enum OnboardingStep {
    case welcomeText
    case finalText
    
    var description: String {
        switch self {
        case .welcomeText:
            return "Immerse in a tranquil Japanese garden. From the whispering Sakura to the beckoning Maneki-neko, guides you through the ancient art of finding the Ikigai—your life's true purpose."
        case .finalText:
            return "In just few minutes, connect with your passions, talents, and the path to fulfillment. Our guided journey is a bridge to inner peace, crafted in the spirit of Japanese mindfulness."
        }
    }
}
