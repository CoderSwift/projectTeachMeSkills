import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelTimeCustomCell: UILabel!
    @IBOutlet weak var labelImageCustomCell: UIImageView!
    @IBOutlet weak var labelTempCustomCell: UILabel!
    var weatherDaily = WeatherCityDaily()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollectionCell(hourleWeather: HourlyWeather?) {
        let date = Date(timeIntervalSince1970: Double(hourleWeather?.dt ?? 0))
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = NSLocale.current
        let dateDaily = dateFormatter.string(from: date)
        self.labelTimeCustomCell.text = "\(dateDaily)  " + "h".localized()
        guard let hourleTemp = hourleWeather?.temp else {return}
        guard let iconHourleWeather = hourleWeather?.weather?.first?.icon else {return}
        self.labelImageCustomCell.image = UIImage(named: iconHourleWeather)
        self.labelTempCustomCell.text = String(Int(hourleTemp))
    }
    
}
