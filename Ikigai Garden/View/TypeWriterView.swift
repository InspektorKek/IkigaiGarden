import SwiftUI

struct TypeWriterView: View {
    @State private var text: String = ""
    private let finalText: String
    private var onCompletion: (() -> Void)?
    
    init(_ text: String, onCompletion: (() -> Void)? = nil) {
        self.finalText = text
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(text)
                .multilineTextAlignment(.leading)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                typeWriter()
            }
        }
    }
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                let index = finalText.index(finalText.startIndex, offsetBy: position)
                text.append(finalText[index])
                typeWriter(at: position + 1)
            }
        } else {
            onCompletion?()
        }
    }
}

#Preview {
    TypeWriterView("Hello, world!")
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
