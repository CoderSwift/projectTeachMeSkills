import Foundation



class SettingsManager {
    
    // Constants
    static let shared = SettingsManager()
    private let defaultSettings = Settings(barriers: "steroids", spaceship: "car_one", level: "1")
    private let key = "settings"
    
    func getSettings () -> Settings {
        if let settings = UserDefaults.standard.object(forKey: key) as? Settings{
            return settings
        }
        return defaultSettings
    }
    
    func setSettings (_ settings: Settings) {
        UserDefaults.standard.set(encodable: settings, forKey: key)
    }
    
}

extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
}
