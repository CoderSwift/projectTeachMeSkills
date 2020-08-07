import SpriteKit
import GameplayKit
import SwiftEntryKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    //    UIElement
    var timerCountdown = Timer()
    var labelCountdown = UILabel()
    var labelScore = UILabel()
    var scoreBox = UIImageView()
    var buttonPause = UIButton()
    var buttonShot = UIButton()
    
    // Variable
    var heightGround  = Int()
    var countdownStartTime = 3
    var buttonPauseСondition = true
    var score:Int = 0 {
        didSet {
            labelScore.text = "\(score) coins"
        }
    }
    
    // OtherElement
    let ncObserver = NotificationCenter.default
    var attriputes = EKAttributes()
    var randomPosition = GKRandomDistribution()
    
    
    // Sprites Nodes
    var moveSequence = SKAction()
    var player = SKSpriteNode()
    var rocket = SKSpriteNode()
    var steroids = SKSpriteNode()
    var coins = SKSpriteNode()
    var explosion = SKSpriteNode()
    var ground = SKSpriteNode()
    var steroidsWidth = 30
    var steroidsHeight = 30
    var coinsWidth = 40
    var coinsHeight = 40
    var carWidth = 60
    var carHeight = 85
    var explosionWidth = 90
    var explosionHeight = 90
    var constantLeftRight = 15
    var scoreBoxWidth = 100
    var scoreBoxHeight = 40
    var buttonPauseWidth = 40
    var buttonPauseHeight = 40
    var heightLimits = 100
    
    
    // Timer
    var animationDuration:TimeInterval = 6
    var gameTimerSteroids = Timer()
    var gameTimerCoins = Timer()
    var animationDurationShot:TimeInterval = 0.3
    var afterPause = 3
    var createSteroidsTimeInterval:Double =  3
    var createCoinsTimeInterval:Double =  4
    var timerStart = Timer()
    
    
    // Mask
    let steroidsCategory:UInt32 = 0x1 << 1
    let carCategory:UInt32 = 0x1 << 0
    let rocketCategory:UInt32 = 0x1 << 3
    let coinsCategory:UInt32 = 0x1 << 2
    
    
    private var settings: Settings?
    
    override func didMove(to view: SKView) {
        installPhysics()
        
        createGrounds()
        createlabelCount()
        createScoreBox()
        createlabelScore()
        startTimer()
        self.createCar()
        timerCountStart()
        createButtonPause()
        createButtonShot()
        determineLevel()
        randomPosition = GKRandomDistribution(lowestValue: 0 + Int(self.steroids.size.width)/2, highestValue: Int((self.view?.frame.size.width)! - self.steroids.size.width))
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveGround()
        let skView = self.view!
        skView.scene?.isPaused = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if player.contains(location) {
                player.position = location
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if player.contains(location) {
                player.position = location
            }
        }
    }
    
    func installPhysics(){
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var explosionBody:SKPhysicsBody
        var carBody:SKPhysicsBody
        var rocketBody:SKPhysicsBody
        var coinsBody:SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            explosionBody = contact.bodyA
            carBody = contact.bodyB
            coinsBody = contact.bodyA
            rocketBody = contact.bodyA
        } else {
            explosionBody = contact.bodyB
            carBody = contact.bodyA
            coinsBody = contact.bodyB
            rocketBody = contact.bodyB
            
        }
        if (carBody.categoryBitMask & steroidsCategory) != 0 {
            explosionDidCollideWithCar(explosionNode: explosionBody.node as! SKSpriteNode, carNode: carBody.node as! SKSpriteNode)
        } else if (explosionBody.categoryBitMask & carCategory) != 0 {
            coinsDidCollideWithCar(carNode: carBody.node as! SKSpriteNode, coinsNode: coinsBody.node as! SKSpriteNode)
        } else if (rocketBody.categoryBitMask & steroidsCategory) != 0 {
            shotDidCollideWithSteroids(steroidsNode: rocketBody.node as! SKSpriteNode, rocketNode: explosionBody.node as! SKSpriteNode)
        }
    }
    
    @objc func pressButtonPause() {
        if self.buttonPauseСondition == true {
            pauseScene()
            buttonPause.setBackgroundImage(UIImage(named: "bg-button-play"), for: .normal)
            buttonPause.setBackgroundImage(UIImage(named: "bg-button-play-active"), for: .highlighted)
            self.buttonPauseСondition = false
            gameTimerSteroids.invalidate()
            timerStart.invalidate()
            gameTimerCoins.invalidate()
            timerCountdown.invalidate()
        } else{
            pauseSceneNoActive()
            buttonPause.setBackgroundImage(UIImage(named: "bg-button-stop"), for: .normal)
            buttonPause.setBackgroundImage(UIImage(named: "bg-button-stop-active"), for: .highlighted)
            self.buttonPauseСondition = true
            if countdownStartTime == 0 {
                timerCountdown.invalidate()
            } else {
                timerCountStart()
            }
            let time = countdownStartTime
            print(time)
            timerStart = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { (_) in
                self.startCointsAndSteroids()
            })
        }
    }
    
    @objc func createSteroids() {
        self.settings = SettingsManager.shared.getSettings()
        guard let steroidsModal = self.settings?.barriers else {return}
        steroids = SKSpriteNode(imageNamed: steroidsModal)
        steroids.size = CGSize(width: steroidsWidth, height: steroidsHeight)
        let position = Double(randomPosition.nextInt())
        steroids.position = CGPoint(x: position, y: Double(self.frame.size.height + steroids.size.height))
        steroids.physicsBody = SKPhysicsBody(circleOfRadius: steroids.frame.size.width/2)
        steroids.zPosition = 3
        steroids.physicsBody?.isDynamic = true
        steroids.physicsBody?.categoryBitMask = steroidsCategory
        steroids.physicsBody?.contactTestBitMask = carCategory
        steroids.physicsBody?.collisionBitMask = 0
        self.addChild(steroids)
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: Double(-heightLimits)), duration: self.animationDuration))
        moveSequence =  SKAction.sequence(actionArray)
        steroids.run(SKAction.repeatForever(moveSequence))
    }
    
    @objc func createСoins() {
        coins = SKSpriteNode(imageNamed: "coins")
        coins.size = CGSize(width: coinsWidth, height: coinsHeight)
        let position = Double(randomPosition.nextInt())
        coins.position = CGPoint(x: position, y: Double(self.frame.size.height + coins.size.height))
        coins.physicsBody = SKPhysicsBody(circleOfRadius: coins.frame.size.width/2)
        coins.zPosition = 3
        coins.physicsBody?.isDynamic = true
        coins.physicsBody?.categoryBitMask = coinsCategory
        coins.physicsBody?.contactTestBitMask = carCategory
        coins.physicsBody?.collisionBitMask = 0
        self.addChild(coins)
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: Double(-heightLimits)), duration: self.animationDuration))
        let moveSequence =  SKAction.sequence(actionArray)
        coins.run(SKAction.repeatForever(moveSequence))
    }
    
    @objc func createRocket(){
           rocket = SKSpriteNode(imageNamed: "rocket")
           rocket.position = player.position
           rocket.position.y += 5
           rocket.physicsBody = SKPhysicsBody(circleOfRadius: rocket.size.width/2)
           rocket.physicsBody?.isDynamic = true
           rocket.physicsBody?.categoryBitMask = rocketCategory
           rocket.physicsBody?.contactTestBitMask = steroidsCategory
           rocket.physicsBody?.collisionBitMask = 0
           rocket.physicsBody?.usesPreciseCollisionDetection = true
           self.addChild(rocket)
           var actionArray = [SKAction]()
           actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDurationShot))
           actionArray.append(SKAction.removeFromParent())
           rocket.run(SKAction.sequence(actionArray))
       }
    
    @objc func prozessTimer() {
        self.countdownStartTime -= 1
        if countdownStartTime == 0 {
            self.labelCountdown.text = String("GO!".localized())
            self.timerCountdown.invalidate()
            animtaionCountdownStartTimeHidden()
        } else{
            self.labelCountdown.text = String(self.countdownStartTime)
        }
    }
    
    func startTimer() {
        timerStart = Timer.scheduledTimer(withTimeInterval: TimeInterval(afterPause), repeats: false, block: { (_) in
            self.startCointsAndSteroids()
        })
    }
    
    func explosionAnimation(_ steroidsNode: SKNode ) {
        let explosionAnim01 = SKTexture.init(imageNamed: "explosion-anim1")
        let explosionAnim02 = SKTexture.init(imageNamed: "explosion-anim2")
        let explosionAnim03 = SKTexture.init(imageNamed: "explosion-anim3")
        let explosionAnim04 = SKTexture.init(imageNamed: "explosion-anim4")
        let explosionAnim05 = SKTexture.init(imageNamed: "explosion-anim5")
        let explosionAnim06 = SKTexture.init(imageNamed: "explosion-anim6")
        let explosionAnim07 = SKTexture.init(imageNamed: "explosion-anim7")
        let frames: [SKTexture] = [explosionAnim01, explosionAnim02, explosionAnim03, explosionAnim04, explosionAnim05, explosionAnim06, explosionAnim07]
        explosion = SKSpriteNode(imageNamed: "explosion-anim1")
        explosion.size = CGSize(width: explosionWidth, height: explosionHeight)
        explosion.position = steroidsNode.position
        explosion.zPosition = 4
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05)
        explosion.run(SKAction.repeatForever(animation))
        self.addChild(explosion)
    }
    
    func shotDidCollideWithSteroids (steroidsNode:SKSpriteNode, rocketNode:SKSpriteNode) {
        steroidsNode.removeFromParent()
        self.rocket.removeFromParent()
        explosionAnimation(steroidsNode)
        _  = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (_) in
            self.explosion.removeFromParent()
        }
        
    }
    
    func determineLevel (){
        self.settings = SettingsManager.shared.getSettings()
        guard let level = self.settings?.level else {return}
        print(level)
        switch Int(level) {
        case 1:
            self.createSteroidsTimeInterval = 3
            self.createCoinsTimeInterval = 4
        case 2:
            self.createSteroidsTimeInterval = 2.6
            self.createCoinsTimeInterval = 4
        case 3:
            self.createSteroidsTimeInterval = 2.2
            self.createCoinsTimeInterval = 3
        case 4:
            self.createSteroidsTimeInterval = 1.8
            self.createCoinsTimeInterval = 3
        case 5:
            self.createSteroidsTimeInterval = 1.4
            self.createCoinsTimeInterval = 2.5
        case 6:
            self.createSteroidsTimeInterval = 1
            self.createCoinsTimeInterval = 2.5
        case 7:
            self.createSteroidsTimeInterval = 0.9
            self.createCoinsTimeInterval = 2.5
        case 8:
            self.createSteroidsTimeInterval = 0.8
            self.createCoinsTimeInterval = 2
        case 9:
            self.createSteroidsTimeInterval = 0.7
            self.createCoinsTimeInterval = 1.8
        case 10:
            self.createSteroidsTimeInterval = 0.5
            self.createCoinsTimeInterval = 1.6
        default:
            break
        }
    }
    
    
    func startCointsAndSteroids(){
        determineLevel ()
        gameTimerSteroids = Timer.scheduledTimer(timeInterval:TimeInterval(createSteroidsTimeInterval), target: self, selector: #selector(createSteroids), userInfo: nil, repeats: true)
        gameTimerCoins.fire()
        gameTimerCoins = Timer.scheduledTimer(timeInterval:TimeInterval(createCoinsTimeInterval), target: self, selector: #selector(createСoins), userInfo: nil, repeats: true)
        gameTimerSteroids.fire()
    }
    
    
    func createCar() {
        self.settings = SettingsManager.shared.getSettings()
        guard let spaceShipModal = self.settings?.spaceship else {return}
        player = SKSpriteNode(imageNamed: spaceShipModal)
        player.size = CGSize(width: carWidth, height: carHeight)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: ((self.scene?.frame.size.width)!)/2, y:self.frame.size.height - self.frame.size.height + CGFloat(heightLimits))
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.size.width/2)
        player.zPosition = 4
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = carCategory
        player.physicsBody?.contactTestBitMask = steroidsCategory
        player.physicsBody?.collisionBitMask = 0
        self.addChild(player)
    }
    
    
    func createGrounds() {
        for i in 0...3 {
            ground = SKSpriteNode(imageNamed: "bg-game")
            self.heightGround = Int(ground.frame.size.height)
            ground.name = "Ground"
            ground.size = CGSize(width: (ground.frame.size.width), height: CGFloat(self.heightGround))
            ground.anchorPoint = CGPoint(x: 0, y: 0)
            ground.position = CGPoint(x: 0, y:   CGFloat(i) * ground.size.height)
            self.addChild(ground)
        }
    }
    
    func moveGround() {
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            node.position.y -= 1.6
            if node.position.y < -CGFloat(self.heightGround) {
                node.position.y += CGFloat(self.heightGround) * 3
            }
        }))
    }
    
    func explosionDidCollideWithCar (explosionNode:SKSpriteNode, carNode:SKSpriteNode) {
        explosionNode.removeFromParent()
        carNode.removeFromParent()
        explosionAnimation(explosionNode)
        _  = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (_) in
            self.explosion.removeFromParent()
            self.timerStart.invalidate()
            self.gameTimerSteroids.invalidate()
            self.gameTimerCoins.invalidate()
            self.showPopupGameOver()
            self.pauseScene()
        }
    }
    
    func coinsDidCollideWithCar (carNode:SKSpriteNode, coinsNode:SKSpriteNode) {
        carNode.removeFromParent()
        self.score += 5
    }
    
    func pauseScene() {
        let skView = self.view!
        skView.scene?.isPaused = true
        
    }
    
    func pauseSceneNoActive(){
        let skView = self.view!
        skView.scene?.isPaused = false
    }
    
    func createScoreBox() {
        scoreBox = UIImageView()
        scoreBox.image = UIImage(named: "bg-coins")
        scoreBox.frame = CGRect(x: 0, y: 0, width: scoreBoxWidth, height: scoreBoxHeight)
        self.view?.addSubview(scoreBox)
        scoreBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreBox.topAnchor.constraint(equalTo: self.view!.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraintTop)),
            scoreBox.rightAnchor.constraint(equalTo: self.view!.rightAnchor, constant: CGFloat(-constantLeftRight))
        ])
    }
    
    func createlabelScore() {
        labelScore = UILabel()
        labelScore.text = String("\(self.score)  " +  "coins".localized())
        labelScore.font = UIFont(name: "BancoDi", size: 16)
        labelScore.textColor = .white
        labelScore.textAlignment = .center
        self.scoreBox.addSubview(labelScore)
        labelScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelScore.heightAnchor.constraint(equalToConstant: 40),
            labelScore.leftAnchor.constraint(equalTo: self.scoreBox.leftAnchor, constant: CGFloat(constantLeftRight)),
            labelScore.rightAnchor.constraint(equalTo: self.scoreBox.rightAnchor, constant: CGFloat(-constantLeftRight))
        ])
    }
    
    func createButtonPause() {
        buttonPause = UIButton()
        buttonPause.frame = CGRect(x: 0, y: 0, width: buttonPauseWidth, height: buttonPauseHeight)
        buttonPause.setBackgroundImage(UIImage(named: "bg-button-stop"), for: .normal)
        buttonPause.setBackgroundImage(UIImage(named: "bg-button-stop-active"), for: .highlighted)
        buttonPause.contentMode = .scaleAspectFill
        buttonPause.addTarget(self, action: #selector(pressButtonPause), for: .touchUpInside)
        self.view?.addSubview(buttonPause)
        buttonPause.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonPause.leftAnchor.constraint(equalTo: self.view!.leftAnchor, constant: CGFloat(constantLeftRight)),
            buttonPause.topAnchor.constraint(equalTo: self.view!.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraintTopPause))
        ])
    }
    
    func createButtonShot(){
        buttonShot = UIButton()
        buttonShot.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        buttonShot.setBackgroundImage(UIImage(named: "button-shot"), for: .normal)
        buttonShot.contentMode = .scaleAspectFill
        self.view?.addSubview(buttonShot)
        buttonShot.translatesAutoresizingMaskIntoConstraints = false
        buttonShot.addTarget(self, action: #selector(createRocket), for: .touchUpInside)
        NSLayoutConstraint.activate([
            buttonShot.rightAnchor.constraint(equalTo: self.view!.rightAnchor, constant: CGFloat(-constantLeftRight)),
            buttonShot.bottomAnchor.constraint(equalTo: self.view!.safeAreaLayoutGuide.bottomAnchor, constant:  CGFloat(-constantLeftRight))
        ])
        
    }
    
    
    func setupAttriputes() -> EKAttributes {
        attriputes = EKAttributes.centerFloat
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
        
        startScene()
        return attriputes
    }
    
    func startScene() {
        attriputes.lifecycleEvents.didDisappear = {
            self.pauseSceneNoActive()
            self.score = 0
            self.startTimer()
            self.removeAllChildren()
            self.createCar()
            self.createGrounds()
            self.labelCountVisable()
        }
    }
    
    func showPopupGameOver() {
        SwiftEntryKit.display(entry: PopupGameOver(frame: CGRect(x: 0, y: 0, width: 215, height: 132), score: "\(self.score)"), using:setupAttriputes())
    }
    
    func labelCountVisable() {
        labelCountdown.alpha = 1
        labelCountdown.text = "3"
        countdownStartTime  = 3
        timerCountStart()
    }
    
    func createlabelCount() {
        labelCountdown = UILabel()
        labelCountdown.text = String("3")
        labelCountdown.font = UIFont(name: "BancoDi", size: 100)
        labelCountdown.textColor = UIColor(hex: "#FFB501ff")
        labelCountdown.textAlignment = .center
        self.view?.addSubview(labelCountdown)
        labelCountdown.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelCountdown.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: 140),
            labelCountdown.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor)
        ])
    }
    
    func timerCountStart() {
        timerCountdown = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(prozessTimer), userInfo: nil, repeats: true)
    }
    
    func animtaionCountdownStartTimeHidden() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.labelCountdown.alpha = 0
            }
        })
    }
    
}


