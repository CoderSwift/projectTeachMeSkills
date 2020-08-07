import Foundation



class ScoreManager {
    
     // Constants
    static let shared = ScoreManager()
    private let defaultSettings = ScoreUser(score: 0, name: "User", date: "")
    private let key = "settings"
    
    // Variable
    var resultArray = [ScoreUser]()

    func getSettings () -> [ScoreUser] {
        if let settings = UserDefaults.standard.value([ScoreUser].self, forKey: key){
            return settings
        }
        return []
    }
    
    func setSettings (_ settings: [ScoreUser]) {
        UserDefaults.standard.set(encodable: settings, forKey: key)
    }
    
}
