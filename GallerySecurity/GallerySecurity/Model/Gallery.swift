
import Foundation

class Gallery: NSObject, Codable {
    var indexArray: Int?
    var uuid: String
    var imageUrls: String?

    
    init(indexArray:Int, imageUrls:String ,uuid:String) {
        self.indexArray = indexArray
    
        self.uuid = uuid
     
        self.imageUrls = imageUrls
    }
    
    public enum CodingKeys: String, CodingKey {
        case uuid, imageUrls, indexArray
    }
    
    public override init() {
        uuid = UUID.init().uuidString
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
         self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String()
        self.imageUrls = try container.decodeIfPresent(String.self, forKey: .imageUrls) ?? String()
        self.indexArray = try container.decodeIfPresent(Int.self, forKey: .indexArray) ?? Int()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
         try container.encode(self.imageUrls, forKey: .imageUrls)
        try container.encode(self.indexArray, forKey: .indexArray)
    }
}


