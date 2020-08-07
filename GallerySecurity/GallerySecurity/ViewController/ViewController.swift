import UIKit



class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    
    var withDurationTime = 0.3
    var withDurationTimeTwoSecond = 2
    var bottomLineWidhtMinus = -00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextFieldPassword()
        self.textFieldPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstRun()
    }
    
    @IBAction func textFieldBegin(_ sender: UITextField) {
        firstTapTextFieldPassword()
    }
    
    @IBAction func buttonMainTouch(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "#229D71ff")
    }
    
    @IBAction func buttonMainTouchUpinside(_ sender: UIButton) {
        sender.backgroundColor = UIColor(hex: "#312E3Fff")
        guard let textPassword = textFieldPassword.text else {return}
        password = textPassword
        UserDefaults.standard.set(password, forKey: "Password")
        if password!.count == 4 {
            let loginInViewController = self.storyboard?.instantiateViewController(identifier: "LoginInViewController") as! LoginInViewController
            loginInViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(loginInViewController, animated: true)
        } else if password!.count > 4 {
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = !string.isEmpty ? textFieldPassword.text!.count + 1 : textFieldPassword.text!.count - 1
        if length > 4 {
            labelErrorShow()
            return false
        }
        return true
    }
    
    func showLoginIn(){
        let loginInViewController = self.storyboard?.instantiateViewController(identifier: "LoginInViewController") as! LoginInViewController
        loginInViewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(loginInViewController, animated: false)
    }
    
    func firstRun() {
        let firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        UserDefaults.standard.synchronize()
        if firstLaunch  {
            showLoginIn()
        }
        else {
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
        }
    }
    
    func labelErrorShow() {
        UIView.animate(withDuration: withDurationTime, animations: {
            self.labelError.alpha = 1
        }) { (_) in
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.withDurationTimeTwoSecond), repeats: false, block: { (_) in
                UIView.animate(withDuration:self.withDurationTime, animations: {
                    self.labelError.alpha = 0
                })
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func styleTextFieldPassword() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.textFieldPassword.frame.height - 1, width: self.view.frame.width - CGFloat(bottomLineWidhtMinus), height: 1.0)
        bottomLine.backgroundColor = UIColor(red:207/255,green:200/255,blue:231/255,alpha:0.4).cgColor
        self.textFieldPassword.borderStyle = UITextField.BorderStyle.none
        self.textFieldPassword.layer.addSublayer(bottomLine)
    }
    
    func  firstTapTextFieldPassword(){
        if textFieldPassword.tag == 0 {
            self.textFieldPassword.text = ""
            self.textFieldPassword.tag = 1
        } else {
        }
    }
    
}



