import UIKit
import Foundation



class SettingsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var textFeildLevel: UITextField!
    @IBOutlet weak var bgImageViewSpaceShipOne: UIImageView!
    @IBOutlet weak var bgImageViewSpaceShipTwo: UIImageView!
    @IBOutlet weak var bgImageViewSpaceShipThree: UIImageView!
    @IBOutlet weak var bgImageViewSteroidsOne: UIImageView!
    @IBOutlet weak var bgImageViewSteroidsTwo: UIImageView!
    @IBOutlet weak var bgImageViewSteroidsThree: UIImageView!
    @IBOutlet weak var imageViewSpaceShipOne: UIImageView!
    @IBOutlet weak var imageViewSpaceShipTwo: UIImageView!
    @IBOutlet weak var imageViewSpaceShipThree: UIImageView!
    @IBOutlet weak var imageViewSteroidsOne: UIImageView!
    @IBOutlet weak var imageViewSteroidsTwo: UIImageView!
    @IBOutlet weak var imageViewSteroidsThree: UIImageView!
    
    // Variable
    private var settings: Settings?
    var level = Int()
    var levelString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButtonBack()
        self.createlabelTitiePage(title: "Settings".localized())
        self.recognizerTapSpaceShip()
        self.settings = SettingsManager.shared.getSettings()
        standartElementBarriers()
        standartElementSpaceShip()
        levelString = self.settings?.level as! String
        level = Int(levelString)!
        self.textFeildLevel.text = "\(level)  " + "level".localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.settings?.level = String(self.level)
    }
    
    @IBAction func buttonPlusLevel(_ sender: UIButton) {
        if self.level == 10{
            
        } else {
            self.level += 1
        }
        textFeildLevel.text = "\(level)  " + "level".localized()
        self.settings?.level = String(level)
    }
    
    @IBAction func buttonMinusLevel(_ sender: UIButton) {
        if self.level == 1 {
            
        } else {
            self.level -= 1
        }
        textFeildLevel.text = "\(level)  " + "level".localized()
        self.settings?.level = String(level)
    }
    
    @objc func tapSpaceShipOne(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.spaceship = "car_one"
        if self.bgImageViewSpaceShipOne.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSpaceShipOne.image = UIImage(named: "bg-element-active")
            self.bgImageViewSpaceShipThree.image = UIImage(named: "bg-element")
            self.bgImageViewSpaceShipTwo.image = UIImage(named: "bg-element")
        }
    }
    
    @objc func tapSpaceShipTwo(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.spaceship = "car_two"
        if self.bgImageViewSpaceShipTwo.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSpaceShipThree.image = UIImage(named: "bg-element")
            self.bgImageViewSpaceShipOne.image = UIImage(named: "bg-element")
            self.bgImageViewSpaceShipTwo.image = UIImage(named: "bg-element-active")
        }
    }
    
    @objc func tapSpaceShipThree(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.spaceship = "car_three"
        if self.bgImageViewSpaceShipThree.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSpaceShipTwo.image = UIImage(named: "bg-element")
            self.bgImageViewSpaceShipOne.image = UIImage(named: "bg-element")
            self.bgImageViewSpaceShipThree.image = UIImage(named: "bg-element-active")
        }
    }
    
    @objc func tapSteroidsOne(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.barriers = "steroids"
        if self.bgImageViewSteroidsOne.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSteroidsOne.image = UIImage(named: "bg-element-active")
            self.bgImageViewSteroidsTwo.image = UIImage(named: "bg-element")
            self.bgImageViewSteroidsThree.image = UIImage(named: "bg-element")
        }
    }
    
    @objc func tapSteroidsTwo(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.barriers = "steroids_two"
        if self.bgImageViewSteroidsTwo.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSteroidsThree.image = UIImage(named: "bg-element")
            self.bgImageViewSteroidsOne.image = UIImage(named: "bg-element")
            self.bgImageViewSteroidsTwo.image = UIImage(named: "bg-element-active")
        }
    }
    
    @objc func tapSteroidsThree(_ gestureRecognizer: UITapGestureRecognizer) {
        self.settings?.barriers = "steroids_three"
        if self.bgImageViewSteroidsThree.image == UIImage(named: "bg-element-active"){
        }else{
            self.bgImageViewSteroidsTwo.image = UIImage(named: "bg-element")
            self.bgImageViewSteroidsOne.image = UIImage(named: "bg-element")
            self.bgImageViewSteroidsThree.image = UIImage(named: "bg-element-active")
        }
    }
    
    func standartElementBarriers(){
           let barriers =  self.settings?.barriers
           switch barriers {
           case "steroids":
               self.bgImageViewSteroidsOne.image = UIImage(named: "bg-element-active")
           case "steroids_two":
               self.bgImageViewSteroidsTwo.image = UIImage(named: "bg-element-active")
           case "steroids_three":
               self.bgImageViewSteroidsThree.image = UIImage(named: "bg-element-active")
           default: break
           }
       }
       
       func standartElementSpaceShip(){
           let spaceship =  self.settings?.spaceship
           switch spaceship {
           case "car_one":
               self.bgImageViewSpaceShipOne.image = UIImage(named: "bg-element-active")
           case "car_two":
               self.bgImageViewSpaceShipTwo.image = UIImage(named: "bg-element-active")
           case "car_three":
               self.bgImageViewSpaceShipThree.image = UIImage(named: "bg-element-active")
           default: break
           }
       }
    
    func recognizerTapSpaceShip(){
          let tapSpaceShipOne = UITapGestureRecognizer(target: self, action: #selector(tapSpaceShipOne(_:)))
          imageViewSpaceShipOne.addGestureRecognizer(tapSpaceShipOne)
          imageViewSpaceShipOne.isUserInteractionEnabled = true
          let tapSpaceShipTwo = UITapGestureRecognizer(target: self, action: #selector(tapSpaceShipTwo(_:)))
          imageViewSpaceShipTwo.addGestureRecognizer(tapSpaceShipTwo)
          imageViewSpaceShipTwo.isUserInteractionEnabled = true
          let tapSpaceShipThree = UITapGestureRecognizer(target: self, action: #selector(tapSpaceShipThree(_:)))
          imageViewSpaceShipThree.addGestureRecognizer(tapSpaceShipThree)
          imageViewSpaceShipThree.isUserInteractionEnabled = true
          let tapSteroidsOne = UITapGestureRecognizer(target: self, action: #selector(tapSteroidsOne(_:)))
          imageViewSteroidsOne.addGestureRecognizer(tapSteroidsOne)
          imageViewSteroidsOne.isUserInteractionEnabled = true
          let tapSteroidsTwo = UITapGestureRecognizer(target: self, action: #selector(tapSteroidsTwo(_:)))
          imageViewSteroidsTwo.addGestureRecognizer(tapSteroidsTwo)
          imageViewSteroidsTwo.isUserInteractionEnabled = true
          let tapSteroidsThree = UITapGestureRecognizer(target: self, action: #selector(tapSteroidsThree(_:)))
          imageViewSteroidsThree.addGestureRecognizer(tapSteroidsThree)
          imageViewSteroidsThree.isUserInteractionEnabled = true
      }
    
}
