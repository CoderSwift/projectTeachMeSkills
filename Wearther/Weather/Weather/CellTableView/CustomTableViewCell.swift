import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBackCell: UIView!
    @IBOutlet weak var labelDayCustomTableCell: UILabel!
    @IBOutlet weak var imageDayCustomTableCell: UIImageView!
    @IBOutlet weak var labelTempCustomTableCell: UILabel!
    var weatherDaily = WeatherCityDaily()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureTableCell(dailyWeather: DailyWeather?) {
        let date = Date(timeIntervalSince1970: Double(dailyWeather?.dt ?? 0))
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = NSLocale.current
        let dateDaily = dateFormatter.string(from: date)
        self.labelDayCustomTableCell.text = dateDaily
        guard let iconDailyWeather = dailyWeather?.weather?.first?.icon else {return}
        self.imageDayCustomTableCell.image = UIImage(named: iconDailyWeather)
        guard let tempDaily = dailyWeather?.temp?.day else {return}
        self.labelTempCustomTableCell.text = String(Int(tempDaily))
    }
    
}
