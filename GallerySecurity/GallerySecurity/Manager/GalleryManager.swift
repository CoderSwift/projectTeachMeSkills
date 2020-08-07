import Foundation

class GalleryManager {
    static let shared = GalleryManager()
    
//    private let defaultSettings = Gallery(indexArray: 0, imageUrls: "", like: false, uuid: "", comment: "Комментировать...")
    private let key = "settings"
    
    func getSettings () -> [Gallery] {
        if let settings = UserDefaults.standard.value([Gallery].self, forKey: key) {
            return settings
        }
        return []
    }
    
    func setSettings (_ settings: Gallery) {
        var arrayImage = self.getSettings()
        arrayImage.append(settings)
        UserDefaults.standard.set(encodable: arrayImage, forKey: key)
        
    }
     func clearUserData(){
        UserDefaults.standard.removeObject(forKey: key)
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
