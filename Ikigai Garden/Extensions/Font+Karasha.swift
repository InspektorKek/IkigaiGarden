import SwiftUI

let karashaFontName: String = "Karasha"

extension View {
    func karashaFont(size: CGFloat = 24) -> some View {
        self.font(.custom(karashaFontName, size: size))
    }
}
