import UIKit
import Foundation
import SwiftEntryKit



class PopupGameOver: UIView {
    
    //  Constants
    let notification = NotificationCenter.default
    
    // Variable
    var backgroundPopup = UIImageView()
    var labelPopup = UILabel()
    var resultCoinsLabel = UILabel()
    var buttonYesPopup = UIButton()
    var imageViewBgScore = UIImageView()
    var textFieldName = UITextField()
    var resultText = String()
    var dateRacing = ""
    var backgroundPopupWidth = 215
    var backgroundPopupHeight = 210
    var imageViewBgScoreWidth = 95
    var imageViewBgScoreHeight = 30
    var imageViewCoinsWidth = 26
    var imageViewCoinsHeight = 33
    var buttonPopupWidth = 75
     var buttonPopupHeight = 35
    var buttonPopupConstantTop = 155
    var buttonPopupConstantLeftRight = 25
    var buttonPopupConstantHeight = 35
    
    
    init(frame: CGRect, score:String) {
        super.init(frame: frame)
        self.resultText = score
        widthAnchor.constraint(equalToConstant: 215).isActive = true
        heightAnchor.constraint(equalToConstant: 210).isActive = true
        self.setupDesignPopup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func pressedButtonYes() {
        saveResultGame()
        SwiftEntryKit.dismiss()
    }
    
    @objc func pressedButtonNo(_: UIButton) {
        saveResultGame()
        SwiftEntryKit.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.notification.post(name: Notification.Name("PressButtonExit"), object: nil)
        }
    }
    
    func saveResultGame(){
        guard let name =  self.textFieldName.text else{return}
        guard let score =  Int(self.resultCoinsLabel.text!) else{return}
        racingDate()
        let scoreValue = ScoreUser(score: score, name: name, date: dateRacing)
        var records = ScoreManager.shared.getSettings()
        records.append(scoreValue)
        
        ScoreManager.shared.setSettings(records)
    }
    
    func setupDesignPopup() {
        backgroundDesignPopup()
        labelDesignPopup()
        buttonYesDesignPopup()
        buttonNoDesignPopup()
        createBgScoreImageView()
        createCoinsImageView()
        createResultCoinsLabel()
        createLabelName()
    }
    
    func backgroundDesignPopup() {
        backgroundPopup = UIImageView()
        backgroundPopup.image = UIImage(named: "bg-popup-game_over")
        backgroundPopup.frame = CGRect(x: 0, y: 0, width: backgroundPopupWidth, height: backgroundPopupHeight)
        self.addSubview(backgroundPopup)
    }
    
    func racingDate() {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = Date()
        dateRacing = dateFormatter.string(from: date)
        _ = date.timeIntervalSince1970
    }
    
    func labelDesignPopup() {
        labelPopup.font = UIFont(name: "BancoDi", size: 26)
        labelPopup.text = "Game Over".localized()
        labelPopup.textColor = .white
        labelPopup.textAlignment = .center
        self.addSubview(labelPopup)
        labelPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelPopup.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(20)),
            labelPopup.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            labelPopup.rightAnchor.constraint(equalTo: rightAnchor, constant:0),
            labelPopup.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    func createBgScoreImageView() {
        imageViewBgScore = UIImageView()
        imageViewBgScore.frame = CGRect(x: 0, y: 0, width: imageViewBgScoreWidth, height: imageViewBgScoreHeight)
        imageViewBgScore.image = UIImage(named: "bg-score")
        self.addSubview(imageViewBgScore)
        imageViewBgScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewBgScore.topAnchor.constraint(equalTo: self.labelPopup.bottomAnchor, constant: CGFloat(15)),
            imageViewBgScore.centerXAnchor.constraint(equalTo: self.backgroundPopup.centerXAnchor),
        ])
    }
    
    func createCoinsImageView() {
        let imageViewCoins = UIImageView()
        imageViewCoins.frame = CGRect(x: 0, y: 0, width: imageViewCoinsWidth, height: imageViewCoinsHeight)
        imageViewCoins.image = UIImage(named: "image-score-coins")
        self.imageViewBgScore.addSubview(imageViewCoins)
        imageViewCoins.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewCoins.leftAnchor.constraint(equalTo: self.imageViewBgScore.leftAnchor, constant: CGFloat(-7)),
            imageViewCoins.topAnchor.constraint(equalTo: self.imageViewBgScore.topAnchor, constant: 0),
        ])
    }
    
    func createResultCoinsLabel() {
        resultCoinsLabel = UILabel()
        resultCoinsLabel.font = UIFont(name: "BancoDi", size: 18)
        resultCoinsLabel.textColor = .white
        
        resultCoinsLabel.text = "\(self.resultText)"
        resultCoinsLabel.textAlignment = .center
        self.imageViewBgScore.addSubview(resultCoinsLabel)
        resultCoinsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultCoinsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            resultCoinsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant:0),
            resultCoinsLabel.centerYAnchor.constraint(equalTo: self.imageViewBgScore.centerYAnchor),
            resultCoinsLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func createLabelName () {
        textFieldName = UITextField()
        textFieldName.font = UIFont(name: "BancoDi", size: 16)
        textFieldName.background = UIImage(named: "label-name")
        textFieldName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textFieldName.frame.height))
        textFieldName.leftViewMode = .always
        textFieldName.text = "User".localized()
        self.addSubview(textFieldName)
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldName.centerXAnchor.constraint(equalTo: self.backgroundPopup.centerXAnchor),
            textFieldName.widthAnchor.constraint(equalToConstant: 175),
            textFieldName.heightAnchor.constraint(equalToConstant: 35),
            textFieldName.topAnchor.constraint(equalTo: self.imageViewBgScore.bottomAnchor, constant: CGFloat(15))
            
        ])
    }
    
    func buttonYesDesignPopup() {
        buttonYesPopup = UIButton()
        buttonYesPopup.setTitle("Return".localized(), for: .normal)
        buttonYesPopup.frame = CGRect(x: 0, y: 0, width: buttonPopupWidth, height: buttonPopupHeight)
        buttonYesPopup.setBackgroundImage(UIImage(named: "bg-button-yes"), for: .normal)
        buttonYesPopup.titleLabel?.font = UIFont(name: "BancoDi", size: 18)
        self.addSubview(buttonYesPopup)
        
        buttonYesPopup.addTarget(self, action: #selector(pressedButtonYes), for: .touchUpInside)
        buttonYesPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonYesPopup.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(buttonPopupConstantTop)),
            buttonYesPopup.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(buttonPopupConstantLeftRight)),
            buttonYesPopup.heightAnchor.constraint(equalToConstant: CGFloat(buttonPopupConstantHeight))
        ])
    }
    
    func buttonNoDesignPopup() {
        let buttonNoPopup = UIButton()
        buttonNoPopup.setTitle("Exit".localized(), for: .normal)
        buttonNoPopup.frame = CGRect(x: 0, y: 0, width: buttonPopupWidth, height: buttonPopupHeight)
        buttonNoPopup.setBackgroundImage(UIImage(named: "bg-button-no"), for: .normal)
        buttonNoPopup.titleLabel?.font = UIFont(name: "BancoDi", size: 18)
        self.addSubview(buttonNoPopup)
        buttonNoPopup.addTarget(self, action: #selector(pressedButtonNo(_:)), for: .touchUpInside)
        buttonNoPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonNoPopup.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(buttonPopupConstantTop)),
            buttonNoPopup.rightAnchor.constraint(equalTo: rightAnchor, constant: -CGFloat(buttonPopupConstantLeftRight)),
            buttonNoPopup.heightAnchor.constraint(equalToConstant: CGFloat(buttonPopupConstantHeight))
        ])
    }
    
}




