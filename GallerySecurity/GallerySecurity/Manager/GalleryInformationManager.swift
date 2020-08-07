import Foundation

class GalleryInformationManager {
    
    // Constants
    static let shared = GalleryInformationManager()
//    private let defaultSettings = GalleryInformation(indexArray: 0, like: false, imageUrls: "", uuid: "", comment: "Комментировать...")
    private let key = "settingsInformation"
    
    // Variable
    var resultArray = [GalleryInformation]()
    
    func getSettings () -> [GalleryInformation] {
        if let settings = UserDefaults.standard.value([GalleryInformation].self, forKey: key){
            return settings
        }
        
        return []
    }
    

    func removeSettings (_ settings: [GalleryInformation]) {
        resultArray.removeAll()
    }
    
    func setSettings (_ settings: [GalleryInformation]) {
        UserDefaults.standard.set(encodable: settings, forKey: key)
    }
    
    
}
