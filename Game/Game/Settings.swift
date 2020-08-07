import Foundation



class Settings: Codable {
    
    // Variable
    var barriers: String
    var spaceship: String
    var level: String
    
    init(barriers:String,spaceship:String,level:String) {
        self.barriers = barriers
        self.spaceship = spaceship
         self.level = level
    }
    
    public enum CodingKeys: String, CodingKey {
        case spaceship, barriers, level
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.barriers, forKey: .barriers)
        try container.encode(self.spaceship, forKey: .spaceship)
          try container.encode(self.level, forKey: .level)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spaceship = try (container.decodeIfPresent(String.self, forKey: .spaceship) ?? "spaceship")
        self.barriers = try (container.decodeIfPresent(String.self, forKey: .barriers) ?? "barriers")
        self.level = try (container.decodeIfPresent(String.self, forKey: .level) ?? "level")
    }
    
}
