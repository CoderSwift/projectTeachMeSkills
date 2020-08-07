import UIKit



class PopupDetailsWeather: UIView {
    
    let labelTitleDetail = UILabel()
    let labelHumidity = UILabel()
    let labelClouds = UILabel()
    let labelSunrise = UILabel()
    let labelSunset = UILabel()
    let labelMarginTop = 10
    let labelMarginRightAndLeft = 15
    let labelHeight = 19
    let labelAnchorTopFirst = 20
    
    init(weatherHumidity: String, weatherClouds:String, weatherSunrise:String, weatherSunset:String ) {
        super.init(frame: UIScreen.main.bounds)
        self.labelHumidity.text = String(weatherHumidity)
        self.labelClouds.text = weatherClouds
        self.labelSunrise.text = weatherSunrise
        self.labelSunset.text = weatherSunset
        setupConstraints()
    }

    func setupConstraints() {
        heightAnchor.constraint(equalToConstant: 180).isActive = true
         labelTitleDetail.translatesAutoresizingMaskIntoConstraints = false
        labelHumidity.translatesAutoresizingMaskIntoConstraints = false
        labelClouds.translatesAutoresizingMaskIntoConstraints = false
        labelSunrise.translatesAutoresizingMaskIntoConstraints = false
        labelSunset.translatesAutoresizingMaskIntoConstraints = false
        labelTitleDetail.text = "Detailed weather".localized()
        labelTitleDetail.textAlignment = .center
        labelTitleDetail.font = UIFont(name: "Montserrat", size: 17)
        labelHumidity.font = UIFont(name: "Montserrat-light", size: 15)
         labelClouds.font = UIFont(name: "Montserrat-light", size: 15)
         labelSunrise.font = UIFont(name: "Montserrat-light", size: 15)
         labelSunset.font = UIFont(name: "Montserrat-light", size: 15)
        labelHumidity.textColor = .white
        labelTitleDetail.textColor = .white
        labelClouds.textColor = .white
        labelSunrise.textColor = .white
        labelSunset.textColor = .white
                addSubview(labelTitleDetail)
        addSubview(labelHumidity)
        addSubview(labelClouds)
        addSubview(labelSunrise)
        addSubview(labelSunset)
        NSLayoutConstraint.activate([
                   labelTitleDetail.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(labelAnchorTopFirst)),
                   labelTitleDetail.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(labelMarginRightAndLeft)),
                   labelTitleDetail.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(labelMarginRightAndLeft)),
                   labelTitleDetail.heightAnchor.constraint(equalToConstant: CGFloat(labelHeight))
               ])
                NSLayoutConstraint.activate([
            labelHumidity.topAnchor.constraint(equalTo: labelTitleDetail.bottomAnchor, constant: 15),
            labelHumidity.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelHumidity.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelHumidity.heightAnchor.constraint(equalToConstant: CGFloat(labelHeight))
        ])
                NSLayoutConstraint.activate([
            labelClouds.topAnchor.constraint(equalTo: labelHumidity.bottomAnchor, constant: CGFloat(labelMarginTop)),
            labelClouds.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelClouds.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelClouds.heightAnchor.constraint(equalToConstant:  CGFloat(labelHeight))
        ])
        NSLayoutConstraint.activate([
            labelSunrise.topAnchor.constraint(equalTo: labelClouds.bottomAnchor, constant: CGFloat(labelMarginTop)),
            labelSunrise.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelSunrise.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelSunrise.heightAnchor.constraint(equalToConstant:  CGFloat(labelHeight))
        ])
                NSLayoutConstraint.activate([
            labelSunset.topAnchor.constraint(equalTo: labelSunrise.bottomAnchor, constant: CGFloat(labelMarginTop)),
            labelSunset.leftAnchor.constraint(equalTo: leftAnchor, constant:CGFloat(labelMarginRightAndLeft)),
            labelSunset.rightAnchor.constraint(equalTo: rightAnchor, constant: CGFloat(labelMarginRightAndLeft)),
            labelSunset .heightAnchor.constraint(equalToConstant:  CGFloat(labelHeight))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
