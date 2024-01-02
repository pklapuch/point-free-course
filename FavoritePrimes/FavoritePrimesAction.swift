import Foundation

public enum FavoritePrimesAction {
    case removeFavoritePrimes(IndexSet)
    case loadedFavoritePrimes([Int])
    case saveButtonTapped
}
