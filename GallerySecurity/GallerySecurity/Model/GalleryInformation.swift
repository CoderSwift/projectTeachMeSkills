
import Foundation

class GalleryInformation: NSObject, Codable {
    var uuid: String
    var indexArray: Int
    var like: Bool?
    var comment: String?
     var imageUrls: String?
    
    init(indexArray:Int,like:Bool, imageUrls:String, uuid:String,comment:String) {
        self.indexArray = indexArray
        self.like = like
        self.like = like
        self.uuid = uuid
         self.imageUrls = imageUrls
        self.comment = comment
    }
    
    public enum CodingKeys: String, CodingKey {
        case like, uuid, comment, indexArray,imageUrls
    }
    
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? String()
         self.indexArray = try container.decodeIfPresent(Int.self, forKey: .indexArray) ?? Int()
        self.like = try container.decodeIfPresent(Bool.self, forKey: .like) ?? Bool()
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? String()
                self.imageUrls = try container.decodeIfPresent(String.self, forKey: .imageUrls) ?? String()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.like, forKey: .like)
         try container.encode(self.imageUrls, forKey: .imageUrls)
        try container.encode(self.indexArray, forKey: .indexArray)
        try container.encode(self.comment, forKey: .comment)
    }
}


