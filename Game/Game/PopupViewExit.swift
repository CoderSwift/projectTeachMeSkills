import UIKit
import SwiftEntryKit



class PopupViewExit: UIView {
    
    // Variable
    var backgroundPopup = UIImageView()
    var labelPopup = UILabel()
    var popupExitConstantWidth = 215
     var popupExitConstantheight = 132
    
    
    var buttonPopupWidth = 75
        var buttonPopupHeight = 35
       var buttonPopupConstantTop = 25
       var buttonPopupConstantLeftRight = 25
       var buttonPopupConstantHeight = 35

    override init(frame: CGRect) {
        super.init(frame: frame)
        widthAnchor.constraint(equalToConstant: CGFloat(popupExitConstantWidth)).isActive = true
        heightAnchor.constraint(equalToConstant: CGFloat(popupExitConstantheight)).isActive = true
        self.setupDesignPopup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pressedButtonNo(_: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @objc func pressedButtonYes(_: UIButton) {
        exit(0)
    }
    
    func setupDesignPopup() {
        backgroundDesignPopup()
        labelDesignPopup()
        buttonYesDesignPopup()
        buttonNoDesignPopup()
    }
    
    func backgroundDesignPopup() {
        backgroundPopup = UIImageView()
        backgroundPopup.image = UIImage(named: "bg-popup-exit")
        backgroundPopup.frame = CGRect(x: 0, y: 0, width: popupExitConstantWidth, height: popupExitConstantheight)
        self.addSubview(backgroundPopup)
    }
    
    func labelDesignPopup() {
        labelPopup.font = UIFont(name: "BancoDi", size: 26)
        labelPopup.text = "Are you sure?".localized()
        labelPopup.textColor = .white
        labelPopup.textAlignment = .center
        self.addSubview(labelPopup)
        labelPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelPopup.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(25)),
            labelPopup.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            labelPopup.rightAnchor.constraint(equalTo: rightAnchor, constant:0),
            labelPopup.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    func buttonYesDesignPopup() {
        let buttonYesPopup = UIButton()
        buttonYesPopup.setTitle("Yes".localized(), for: .normal)
        buttonYesPopup.frame = CGRect(x: 0, y: 0, width: buttonPopupWidth, height: buttonPopupHeight)
        buttonYesPopup.setBackgroundImage(UIImage(named: "bg-button-yes"), for: .normal)
        buttonYesPopup.titleLabel?.font = UIFont(name: "BancoDi", size: 18)
        self.addSubview(buttonYesPopup)
        buttonYesPopup.addTarget(self, action: #selector(pressedButtonYes(_:)), for: .touchUpInside)
        buttonYesPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonYesPopup.topAnchor.constraint(equalTo: self.labelPopup.bottomAnchor, constant: CGFloat(buttonPopupConstantTop)),
            buttonYesPopup.leftAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(buttonPopupConstantLeftRight)),
            buttonYesPopup.heightAnchor.constraint(equalToConstant: CGFloat(buttonPopupConstantHeight))
        ])
        
    }
    
    func buttonNoDesignPopup() {
        let buttonNoPopup = UIButton()
        buttonNoPopup.setTitle("No".localized(), for: .normal)
        buttonNoPopup.frame = CGRect(x: 0, y: 0, width: buttonPopupWidth, height: buttonPopupHeight)
        buttonNoPopup.setBackgroundImage(UIImage(named: "bg-button-no"), for: .normal)
        buttonNoPopup.titleLabel?.font = UIFont(name: "BancoDi", size: 18)
        self.addSubview(buttonNoPopup)
        buttonNoPopup.addTarget(self, action: #selector(pressedButtonNo(_:)), for: .touchUpInside)
        buttonNoPopup.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonNoPopup.topAnchor.constraint(equalTo: self.labelPopup.bottomAnchor, constant: CGFloat(buttonPopupConstantTop)),
            buttonNoPopup.rightAnchor.constraint(equalTo: rightAnchor, constant: -CGFloat(buttonPopupConstantLeftRight)),
            buttonNoPopup.heightAnchor.constraint(equalToConstant: CGFloat(buttonPopupConstantHeight))
        ])
    }
    
}

