import Foundation

struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []

    struct Activity {
      let timestamp: Date
      let type: ActivityType

      enum ActivityType {
        case addedFavoritePrime(Int)
        case removedFavoritePrime(Int)
      }
    }

    struct User {
      let id: Int
      let name: String
      let bio: String
    }
}
