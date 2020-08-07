import UIKit
import CoreLocation
import SwiftEntryKit



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainerSearch: UIView!
    @IBOutlet weak var viewContainerBlurSearch: UIVisualEffectView!
    @IBOutlet weak var viewContainerBlurInnerSearch: UIView!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var labelCityTopMain: UILabel!
    @IBOutlet weak var imageStatusWeatherMain: UIImageView!
    @IBOutlet weak var labelTempMain: UILabel!
    @IBOutlet weak var labelWeekdayMain: UILabel!
    
    let arrayColor = ["#7fb5f1ff", "#f0a65fff", "#eb5e80ff", "#a67df3ff", "#68e0bcff", "#910eb7ff", "#e90732ff"]
    var collectionCellView = CustomCollectionViewCell()
    var managerLocation =  CLLocationManager()
    var coordinates: CLLocation?
    var temp:String = ""
    var dateNow:String = ""
    var coordinateLon = CLLocationDegrees()
    var coordinateLat = CLLocationDegrees()
    var weatherDailyTuples = [(tempDaily: Double?,  iconDaily:String?)]()
    var weatherDailyArray = [Any]()
    var weatherDaily = WeatherCityDaily()
    var dailyCount = 7
    var hourlyCount = 24
    var leadingAnchor = 15
    var country = String()
    var viewModel: ViewModel?
    var viewContainerSearchAnchorLeft = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        styleButtonSearch()
        styleStandartElement()
        self.weekDayDate()
        self.createCustomCollectionViewCell()
        self.createCustomTableViewCell()
        self.backgroundMainView()
        createConstrain()
    }
    
    func styleStandartElement(){
        viewModel = ViewModel()
        self.viewContainerBlurSearch.layer.cornerRadius = 22.5
        self.textFieldSearch.layer.cornerRadius = 22.5
        self.viewContainerBlurInnerSearch.layer.cornerRadius = 22.5
        self.viewContainerBlurSearch.layer.masksToBounds = true
        self.buttonSearch.layer.cornerRadius = 22.5
    }
    
    func createConstrain () {
        self.viewContainerSearchAnchorLeft = viewContainerSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.size.width - self.buttonSearch.frame.size.width - CGFloat(leadingAnchor))
        self.viewContainerSearchAnchorLeft.isActive = true
    }
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3), dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.shadow = .active(with: .init(color: .black,opacity: 0.3,radius:10))
        attributes.screenInteraction = .dismiss
        attributes.entryBackground = .color(color: EKColor(UIColor(hex: "#7fb5f1ff")!))
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.7, anchorPosition: .bottom, spring: .init(damping: 1, initialVelocity: 0)),
            scale: .init(from: 0.6, to: 1, duration: 0.7),
            fade: .init(from: 0.8, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(translate: .init(duration: 0.2))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        return attributes
    }
    
    @IBAction func buttonShowDetailsWeather(_ sender: UIButton) {
        guard let weatherHumidity = self.weatherDaily.current?.humidity else{return}
        guard let weatherClouds = self.weatherDaily.current?.clouds else{return}
        guard let weatherSunrise = self.weatherDaily.current?.sunrise else{return}
        guard let weatherSunset = self.weatherDaily.current?.sunset else{return}
        let dateSunrise = Date(timeIntervalSince1970: Double(weatherSunrise ))
        let dateSunset = Date(timeIntervalSince1970: Double(weatherSunset ))
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        dateFormatter.locale = NSLocale.current
        let weatherSunriseTime = dateFormatter.string(from: dateSunrise)
        let weatherSunsetTime = dateFormatter.string(from: dateSunset)
        SwiftEntryKit.display(entry: PopupDetailsWeather(weatherHumidity: "Humidity: ".localized() + "\(weatherHumidity) %", weatherClouds: "Cloudiness: ".localized() + "\(weatherClouds)", weatherSunrise: "Sunrise time: ".localized() + "\(weatherSunriseTime)", weatherSunset: "Sunset time: ".localized() + "\(weatherSunsetTime)"), using: setupAttributes())
    }
    
    @IBAction func buttonSearchTap(_ sender: UIButton) {
        if self.buttonSearch.tag == 0{
            self.buttonSearch.tag = 1
            self.viewContainerSearchAnchorLeft.constant = 15
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        } else {
            self.buttonSearch.tag = 0
            self.country = self.textFieldSearch.text!
            self.urlLink()
            view.endEditing(true)
            self.viewContainerSearchAnchorLeft.constant = CGFloat(view.frame.size.width - self.buttonSearch.frame.size.width - CGFloat(leadingAnchor))
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                self.textFieldSearch.text = ""
            }
        }
    }
    
    func styleButtonSearch() {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.textFieldSearch.frame.height))
        textFieldSearch.leftView = paddingView
        textFieldSearch.leftViewMode = UITextField.ViewMode.always
        viewContainerSearch.layer.cornerRadius = viewContainerSearch.bounds.height / 2
        viewContainerSearch.layer.shadowRadius = 4.0
        viewContainerSearch.layer.shadowOpacity = 0.1
        viewContainerSearch.layer.shadowOffset = CGSize.zero
    }
    
    func setupLocation() {
        managerLocation.delegate = self
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest
        managerLocation.requestAlwaysAuthorization()
        managerLocation.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinates = locations.last
        managerLocation.startUpdatingLocation()
        guard let coordinates = coordinates else{return}
        self.coordinateLon = coordinates.coordinate.longitude
        self.coordinateLat = coordinates.coordinate.latitude
        self.urlLink()
    }
    
    func urlLink() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinateLat)&lon=\(coordinateLon)&appid=20b2da30a9fa5a6c5986270006fa2587&units=metric&q=\(self.country)"
        let urlStringDaily = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinateLat)&lon=\(coordinateLon)&appid=20b2da30a9fa5a6c5986270006fa2587&units=metric"
        self.WeatherInCity(with: urlString)
        self.WeatherInCityDaily(with: urlStringDaily)
    }
    
    func weekDayDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dateString = dateFormatter.string(from: Date.init())
        self.labelWeekdayMain.text = dateString
    }
    
    //MARK: - ManagerWeatherCurrent
    func WeatherInCity(with urlString: String) {
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                let data = data else {return}
            do {
                let weatherMain = try JSONDecoder().decode(WeatherCity.self, from: data)
                guard let tempName = weatherMain.main?.temp else {return}
                DispatchQueue.main.async { // Correct
                    self.labelTempMain.text = String(Int(tempName))
                    self.labelCityTopMain.text = weatherMain.name
                    guard let iconWeather = weatherMain.weather[0]?.icon else {return}
                    self.imageStatusWeatherMain.image = UIImage(named: iconWeather)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    //MARK: - ManagerWeatherDaily
    func WeatherInCityDaily(with urlStringDaily: String) {
        guard let urlDaily = URL(string: urlStringDaily) else {return}
        var requestDaily = URLRequest(url: urlDaily)
        requestDaily.httpMethod = "GET"
        let taskDaily = URLSession.shared.dataTask(with: requestDaily) { (data, response, error) in
            guard error == nil,
                let data = data else {return}
            do {
                self.weatherDaily = try JSONDecoder().decode(WeatherCityDaily.self, from: data)
                DispatchQueue.main.async { // Correct
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        taskDaily.resume()
    }
    
    func backgroundMainView() {
        self.imageViewBackground.contentMode = .scaleToFill
        let dateFormatterDayAndNight = DateFormatter()
        dateFormatterDayAndNight.dateFormat = "HH"
        let dateStringDayAndNight = dateFormatterDayAndNight.string(from: Date.init())
        if Int(dateStringDayAndNight)! >= 21 || Int(dateStringDayAndNight)! <= 7 {
            self.imageViewBackground.image = UIImage(named: "night")
            guard let collectionCellViewTime = self.collectionCellView.labelTimeCustomCell else {return}
            guard let collectionCellViewTemp = self.collectionCellView.labelTempCustomCell else {return}
            collectionCellViewTime.textColor = .white
            collectionCellViewTemp.textColor = .white
        } else {
            self.imageViewBackground.image = UIImage(named: "day")
            guard let collectionCellViewTime = self.collectionCellView.labelTimeCustomCell else {return}
            guard let collectionCellViewTemp = self.collectionCellView.labelTempCustomCell else {return}
            collectionCellViewTime.textColor = .black
            collectionCellViewTemp.textColor = .black
        }
    }
    
    func createCustomCollectionViewCell() {
        let nibCollectionViewCell = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(nibCollectionViewCell, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    func createCustomTableViewCell() {
        let nibTableViewCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.tableView.register(nibTableViewCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hourlyCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 5
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 70, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.configureCollectionCell(hourleWeather: weatherDaily.hourly?[indexPath.row])
        cell.backgroundColor =  UIColor(hex: arrayColor[indexPath.row % arrayColor.count])
        cell.layer.cornerRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTable = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
        cellTable!.frame = cellTable!.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        cellTable?.viewBackCell.layer.cornerRadius = 5
        cellTable?.viewBackCell.backgroundColor =  UIColor(hex: arrayColor[indexPath.row % arrayColor.count])
        cellTable?.configureTableCell(dailyWeather: weatherDaily.daily?[indexPath.row])
        return cellTable!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}






