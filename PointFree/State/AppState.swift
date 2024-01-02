import Foundation
import Counter

struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []
    var alertNthPrime: NthPrimeAlert?
    var isNthPrimeButtonDisable = false

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
