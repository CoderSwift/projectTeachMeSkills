import UIKit
import SpriteKit
import GameplayKit
import SwiftEntryKit


var constraintTop = 5
var constraintTopTitle = 8
var constraintTopPause = 55

class GameViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var SkView: SKView!
    
    // Variable
    var ncObserver = NotificationCenter.default
    private var settings: Settings?

    //    Сonstants
    let notification = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            SkView = view
        }
        self.createButtonBack()
        ncObserver.addObserver(self, selector: #selector(backView), name: Notification.Name("PressButtonExit"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func backView() {
        SwiftEntryKit.dismiss()
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}

extension UIViewController {
    
    func createButtonBack() {
        let buttonBack = UIButton()
        buttonBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonBack.setBackgroundImage(UIImage(named: "button-back"), for: .normal)
        buttonBack.setBackgroundImage(UIImage(named: "button-back-active"), for: .highlighted)
        buttonBack.contentMode = .scaleAspectFill
        buttonBack.addTarget(self, action: #selector(moveBackMenu), for: .touchUpInside)
        self.view.addSubview(buttonBack)
        
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            buttonBack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraintTop))
        ])
    }
    
    @objc func moveBackMenu(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func createlabelTitiePage(title: String) {
        let labelTitlePage = UILabel()
        labelTitlePage.text = title
        labelTitlePage.textColor = .white
        labelTitlePage.font = UIFont(name: "BancoDi", size: 40)
        labelTitlePage.textAlignment = .center
        self.view.addSubview(labelTitlePage)
        labelTitlePage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitlePage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraintTopTitle)),
            labelTitlePage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
