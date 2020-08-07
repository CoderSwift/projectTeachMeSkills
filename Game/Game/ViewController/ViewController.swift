import UIKit
import SwiftEntryKit
import AVFoundation



class ViewController: UIViewController {
    // Outlets
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonRecords: UIButton!
    @IBOutlet weak var buttonSettings: UIButton!
    @IBOutlet weak var buttonExit: UIButton!
    @IBOutlet weak var buttonSound: UIButton!
    
    // Variable
    var button = UIButton()
    var buttonSoundCheck = true
    var musicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerMusic()
    }
    
    func setupAttriputes() -> EKAttributes {
        var attriputes = EKAttributes.centerFloat
        attriputes.displayDuration = .infinity
        attriputes.screenBackground = .color(color: .init(light: UIColor(white: 0,
                                                                         alpha: 0.3),
                                                          dark: UIColor(white: 0,
                                                                        alpha: 0.3)))
        attriputes.shadow = .active(with: .init(color: .black,
                                                opacity: 0.3,
                                                radius: 10,
                                                offset: .zero))
        attriputes.screenInteraction = .dismiss
        attriputes.entryInteraction = .absorbTouches
        attriputes.entranceAnimation = .init( scale: .init(from: 0.6, to: 1, duration: 0.3),
                                              fade: .init(from: 0.8, to: 1, duration: 0.3))
        attriputes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.3, duration: 0.7)))
        attriputes.exitAnimation = .init( scale: .init(from: 1, to: 0.6, duration: 0.3),
                                          fade: .init(from: 1, to: 0.8, duration: 0.3))
        return attriputes
    }
    
    @IBAction func buttonStart(_ sender: UIButton) {
        print("tap")
        let showGameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as!  GameViewController
        showGameViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(showGameViewController, animated: true)
    }
    
    @IBAction func buttonRecords(_ sender: UIButton) {
        let showRecordsViewController =  self.storyboard?.instantiateViewController(withIdentifier: "RecordsViewController") as! RecordsViewController
        showRecordsViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(showRecordsViewController, animated: true)
    }
    
    @IBAction func buttonSettings(_ sender: UIButton) {
        let showSettingsViewController =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        showSettingsViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(showSettingsViewController, animated: true)
    }
    
    @IBAction func buttonExitTap(_ sender: UIButton) {
        SwiftEntryKit.display(entry: PopupViewExit(frame: CGRect(x: 0, y: 0, width: 215, height: 132)), using:setupAttriputes())
    }
    
    @IBAction func buttonSoundTap(_ sender: UIButton) {
        pressedButtonSound()
    }
    
    func pressedButtonSound() {
        if buttonSoundCheck == true {
            self.buttonSoundCheck = false
            musicPlayer?.stop()
            self.buttonSound.setImage(UIImage(named: "icon-sound-off"), for: .normal)
        } else {
            musicPlayer?.play()
            self.buttonSoundCheck = true
            self.buttonSound.setImage(UIImage(named: "icon-sound-on"), for: .normal)
        }
    }
    
    func playerMusic() {
        let path = Bundle.main.path(forResource: "music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.play()
            musicPlayer?.numberOfLoops = -1
        } catch {
            
        }
    }
    
}



