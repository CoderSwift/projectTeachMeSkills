import UIKit



class LoginInViewController: UIViewController {
    
   
    
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonNumber1: UIButton!
    @IBOutlet weak var buttonNumber2: UIButton!
    @IBOutlet weak var buttonNumber3: UIButton!
    @IBOutlet weak var buttonNumber4: UIButton!
    @IBOutlet weak var buttonNumber5: UIButton!
    @IBOutlet weak var buttonNumber6: UIButton!
    @IBOutlet weak var buttonNumber7: UIButton!
    @IBOutlet weak var buttonNumber8: UIButton!
    @IBOutlet weak var buttonNumber9: UIButton!
    @IBOutlet weak var buttonNumber0: UIButton!
    @IBOutlet weak var buttonNumberClose: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    var withTimeInterval = 0.3
    var passwordEnter = ""
    var passwordLength = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonNumberStyle()
    }
    
    @IBAction func buttonChangePassword(_ sender: UIButton) {
        password = ""
        UserDefaults.standard.set(false, forKey: "FirstLaunch")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonNumberTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:207/255,green:200/255,blue:231/255,alpha:0.28)
        passwordEnter += "\(sender.tag)"
        if passwordEnter.count <= 4 {
            self.textFieldPassword.text = String(passwordEnter)
            passwordVerification()
        }  else {
        }
    }
    
    @IBAction func buttonNumberAction(_ sender: UIButton) {
        sender.backgroundColor = .clear
    }
    
    @IBAction func buttonCloseTouchDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "#BB4040ff")
    }
    
    @IBAction func buttonClose(_ sender: UIButton) {
        sender.backgroundColor = .clear
        passwordEnter = ""
        self.textFieldPassword.text = ""
        buttonNextHide()
    }
    
    @IBAction func buttonShowGalleryViewController(_ sender: UIButton) {
        let galleryViewController = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as! GalleryViewController
        galleryViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    func buttonNumberStyle(){
        let buttonHeightWidth = self.buttonNumber1.frame.size.width/2
        buttonNumber1.layer.cornerRadius = buttonHeightWidth
        buttonNumber2.layer.cornerRadius = buttonHeightWidth
        buttonNumber3.layer.cornerRadius = buttonHeightWidth
        buttonNumber4.layer.cornerRadius = buttonHeightWidth
        buttonNumber5.layer.cornerRadius = buttonHeightWidth
        buttonNumber6.layer.cornerRadius = buttonHeightWidth
        buttonNumber7.layer.cornerRadius = buttonHeightWidth
        buttonNumber8.layer.cornerRadius = buttonHeightWidth
        buttonNumber9.layer.cornerRadius = buttonHeightWidth
        buttonNumber0.layer.cornerRadius = buttonHeightWidth
        buttonNumberClose.layer.cornerRadius = buttonHeightWidth
        buttonNext.layer.cornerRadius = buttonHeightWidth
    }
    
    func buttonNextShow(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: withTimeInterval, animations: {
            self.buttonNext.alpha = 1
        }) { (_) in
        }
    }
    
    func buttonNextHide(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: withTimeInterval, animations: {
            self.buttonNext.alpha = 0
        }) { (_) in
        }
    }
    
    func passwordVerification() {
        if passwordEnter.count == passwordLength {
            if passwordEnter == password {
                buttonNextShow()
            } else {
                self.textFieldPassword.textColor = UIColor(hex: "#BB4040ff")
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                    self.textFieldPassword.textColor = UIColor(hex: "#ffffffff")
                    self.textFieldPassword.text = ""
                    self.passwordEnter = ""
                })
            }
        } else {
            
        }
    }
    
}


