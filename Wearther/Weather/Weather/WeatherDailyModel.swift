import Foundation


struct WeatherCityDaily: Decodable {
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var current: CurrentWeather?
    var hourly: [HourlyWeather]?
    var daily: [DailyWeather]?
}

struct CurrentWeather: Decodable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
    var humidity: Int?
    var dew_point: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var wind_speed: Double?
    var wind_deg: Double?
    var weather: [WeatherDaily]?
}

struct WeatherDaily: Decodable {
    var id: Double?
    var main: String?
    var description: String?
    var icon: String?
}

struct HourlyWeather: Decodable {
    var dt: Int?
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
    var humidity: Int?
    var dew_point: Double?
    var clouds: Int?
    var wind_speed: Double?
    var wind_deg: Double?
    var weather: [WeatherDaily]?
}

struct DailyWeather:Decodable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var temp: DailyWeatherTemp?
    var feels_like: DailyWeatherLike?
    var pressure: Int?
    var humidity: Int?
    var dew_point: Double?
    var wind_speed: Double?
    var wind_deg: Double?
    var weather: [WeatherDaily]?
     var clouds: Int?
    var rain: Double?
    var uvi: Double?
}

struct DailyWeatherTemp:Decodable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

struct DailyWeatherLike:Decodable {
    var day: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}
