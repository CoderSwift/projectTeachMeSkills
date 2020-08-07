import Foundation



class ScoreUser: Codable {
    
    // Variable
    var name: String?
    var date: String?
    var score: Int?

    init(score:Int,name:String,date:String) {
        self.score = score
        self.name = name
        self.date = date
    }
    
    public enum CodingKeys: String, CodingKey {
           case name, score, date
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.score = try container.decodeIfPresent(Int.self, forKey: .score)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.score, forKey: .score)
         try container.encode(self.date, forKey: .date)
    }
    
}


