import UIKit

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var MainPhotoImageView: UIImageView!
    @IBOutlet weak var sliderBox: UIView!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var scrollViewInner: UIView!
    @IBOutlet weak var textFieldEnterText: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewButtonBox: UIView!
    @IBOutlet weak var scrollViewInnerConstrains: NSLayoutConstraint!
    
    let paragraphStyle = NSMutableParagraphStyle()
    var buttonBack = UIButton()
    var indexArray = 0
    var indexArrayGalleryOther = Int()
    let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
    var nextPhotoImageView = UIImageView()
    var prevPhotoImageView = UIImageView()
    var animationDuration = 0.3
    var custom: CustomCollectionViewCell!
    var indexPath:IndexPath!
    var countSlideNext = Int()
    var countSlidePrev = Int()
    var imageLike = false
    var gallery = GalleryManager.shared.getSettings()
    var galleryInformation = GalleryInformationManager.shared.getSettings()
    var arrayPhotoGallery = [(indexArray:Int, imageUrls:UIImage, like:Bool, uuid: String, comment: String)]()
    var galleryInformationArray = [(indexArray:Int, imageUrls:UIImage, like:Bool, uuid: String, comment: String)]()
    var minHeightFrame = 700
    var buttonBackSize = 45
    var buttonBackConstantTop = 35
    var buttonBackConstantLeft = 25
    var buttonBackConstantheightWidth = 45
    var viewButtonBoxRadius = 22.5
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        createButtonBack()
        textFieldEnterTextStyle()
        nextPhoto()
        prevPhoto()
        addSwipe()
        setImage()
        self.indexNextAndPrev()
        setupStandartSettings()
        indexMainImage()
        favoriteImage()
        setupNotification()
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        indexMainImage()
        favoriteImageSave(indexArrayGallery)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func buttonFavoriteAction(_ sender: UIButton) {
        if buttonFavorite.tag == 0{
            buttonFavorite.tag = 1
            buttonFavorite.setImage(UIImage(named: "icon-favorite-active"), for: .normal)
            imageLike = true
        } else {
            buttonFavorite.tag = 0
            buttonFavorite.setImage(UIImage(named: "icon-favorite"), for: .normal)
            imageLike = false
        }
    }
    
    @IBAction func textFieldDidBegin(_ sender: UITextField) {
        self.textFieldEnterText.text = ""
    }
    
    @IBAction func buttonSendComment(_ sender: UIButton){
        writeComment()
        hideKeyboard()
    }
    
    @IBAction func buttonFavoriteDown(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:55/255,green:52/255,blue:71/255,alpha:1)
    }
    
    @IBAction func buttonFavorite(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:55/255,green:52/255,blue:71/255,alpha:0)
    }
    
    @objc func buttonBackActionDown () {
        buttonBack.backgroundColor = UIColor(red:55/255,green:52/255,blue:71/255,alpha:1)
    }
    
    @objc func buttonBackActionInside () {
        buttonBack.backgroundColor = UIColor(red:55/255,green:52/255,blue:71/255,alpha:0.40)
        let backGalleryViewController = self.storyboard?.instantiateViewController(identifier: "GalleryViewController") as! GalleryViewController
        backGalleryViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(backGalleryViewController, animated: true)
        indexMainImage()
        favoriteImageSave(indexArrayGallery)
    }
    
    @objc func keyboardWillChange(notification:Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else{
            view.frame.origin.y = 0
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            indexImageNextAndPrev(self.galleryInformationArray[self.countSlidePrev].imageUrls)
            indexMainImageOther()
            favoriteImageSave(indexArrayGalleryOther)
            favoriteImage()
            self.countSliderPrev()
            self.nextPhotoImageView.image = self.MainPhotoImageView.image
            self.MainPhotoImageView.image = self.prevPhotoImageView.image
            self.prevPhotoImageView.image = self.galleryInformationArray[self.countSlidePrev].imageUrls
            self.MainPhotoImageView.frame.origin.x = 0
            self.prevPhotoImageView.frame.origin.x = self.prevPhotoImageView.frame.origin.x - self.MainPhotoImageView.frame.size.width
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            indexImageNextAndPrev(self.galleryInformationArray[self.countSlideNext].imageUrls)
            indexMainImageOther()
            favoriteImageSave(indexArrayGalleryOther)
            favoriteImage()
            self.prevPhotoImageView.image = self.MainPhotoImageView.image
            self.countSliderNext()
            self.MainPhotoImageView.image = self.nextPhotoImageView.image
            self.nextPhotoImageView.image = self.galleryInformationArray[self.countSlideNext].imageUrls
            self.MainPhotoImageView.frame.origin.x = 0
            self.nextPhotoImageView.frame.origin.x = self.MainPhotoImageView.frame.size.width
        }
    }
    
    func mainImageAspereRatio(){
        if self.view.frame.height < CGFloat(minHeightFrame) {
            self.scrollViewInnerConstrains.constant = 8.0/8.0
        } else {
            self.scrollViewInnerConstrains.constant = 8.0/10.0
        }
    }
    
    func hideKeyboard() {
        textFieldEnterText.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        writeComment()
        hideKeyboard()
        return true
    }
    
    func createButtonBack() {
        buttonBack.frame = CGRect(x: 0, y: 0, width: buttonBackSize, height: buttonBackSize)
        buttonBack.backgroundColor =  UIColor(red:55/255,green:52/255,blue:71/255,alpha:0.70)
        buttonBack.setImage(UIImage(named: "icon-arrowBack"), for: .normal)
        buttonBack.setImage(UIImage(named: "icon-arrowBack"), for: .highlighted)
        buttonBack.layer.cornerRadius = buttonBack.frame.size.width/2
        buttonBack.addTarget(self, action: #selector(buttonBackActionDown), for: .touchDown)
        buttonBack.addTarget(self, action: #selector(buttonBackActionInside), for: .touchUpInside)
        self.view.addSubview(buttonBack)
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(buttonBackConstantTop)),
            buttonBack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(buttonBackConstantLeft)),
            buttonBack.heightAnchor.constraint(equalToConstant: CGFloat(buttonBackConstantheightWidth)),
            buttonBack.widthAnchor.constraint(equalToConstant: CGFloat(buttonBackConstantheightWidth))
        ])
    }
    
    func textFieldEnterTextStyle(){
        textFieldEnterText.layer.cornerRadius = textFieldEnterText.frame.size.height/2
        textFieldEnterText.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        textFieldEnterText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldEnterText.frame.height))
        textFieldEnterText.leftViewMode = .always
        textFieldEnterText.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldEnterText.frame.height))
        textFieldEnterText.rightViewMode = .always
        
    }
    
    func indexNextAndPrev() {
        if indexPath.item == galleryInformationArray.count - 1 {
            self.countSlideNext = 0
        } else {
            self.countSlideNext = indexPath.item + 1
        }
        if indexPath.item == 0 {
            self.countSlidePrev = galleryInformationArray.count - 1
        } else {
            self.countSlidePrev =  indexPath.item - 1
        }
    }
    
    
    func setImage() {
        for element in galleryInformation{
            let indexArray = element.indexArray
            guard let imageLike = element.like else {return}
            guard let imageUrl = element.imageUrls else {return}
            guard let imageComment = element.comment else {return}
            guard let image = loadSave(fileName:imageUrl) else {return}
            let uuid = element.uuid
            self.galleryInformationArray.append((indexArray:indexArray, imageUrls:image, like:imageLike, uuid: uuid, comment: imageComment ?? "Comments..."))
        }
    }
    
    func indexMainImageOther() {
        for element in galleryInformationArray{
            if element.imageUrls == self.MainPhotoImageView.image {
                indexArrayGalleryOther = element.indexArray
            }
        }
    }
    
    func indexMainImage() {
        for element in galleryInformationArray{
            if element.imageUrls == self.MainPhotoImageView.image {
                indexArrayGallery = element.indexArray
            }
        }
    }
    
    func indexImageNextAndPrev(_ sender: UIImage) {
        for element in galleryInformationArray{
            if element.imageUrls == sender {
                indexArrayGallery = element.indexArray
            }
        }
    }
    
    func favoriteImage(){
        for element in galleryInformationArray {
            if element.indexArray == indexArrayGallery {
                if element.like == true {
                    imageLike = true
                    buttonFavorite.tag = 1
                    buttonFavorite.setImage(UIImage(named: "icon-favorite-active"), for: .normal)
                } else {
                    imageLike = false
                    buttonFavorite.tag = 0
                    buttonFavorite.setImage(UIImage(named: "icon-favorite"), for: .normal)
                }
                self.label.text = element.comment ?? "Comments...".localized()
            }
        }
    }
    
    func favoriteImageSave(_ sender: Int){
        for element in galleryInformationArray {
            if element.indexArray == sender {
                let indexPath = element.indexArray
                let imageComment = self.label.text
                let likeImg = imageLike
                var galleryInformation = GalleryInformationManager.shared.getSettings()
                galleryInformation[sender].like = likeImg
                galleryInformation[sender].comment = String(imageComment!)
                galleryInformationArray[sender].like = likeImg
                galleryInformationArray[sender].comment = String(imageComment!)
                GalleryInformationManager.shared.setSettings(galleryInformation)
            }
        }
    }
    
    func setupStandartSettings(){
        view.layer.masksToBounds = true
        MainPhotoImageView.image = self.galleryInformationArray[indexPath.item].imageUrls
        nextPhotoImageView.image = self.galleryInformationArray[countSlideNext].imageUrls
        prevPhotoImageView.image = self.galleryInformationArray[countSlidePrev].imageUrls
        MainPhotoImageView.contentMode = .scaleAspectFill
        self.viewButtonBox.layer.cornerRadius = CGFloat(viewButtonBoxRadius)
        self.viewButtonBox.layer.masksToBounds = true
        textFieldEnterText.delegate = self
    }
    
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func writeComment(){
        self.label.text = textFieldEnterText.text
        textFieldEnterText.text = ""
        favoriteImageSave(indexArrayGallery)
    }
    
    func addSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view!.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
    }
    
    func countSliderNext() {
        if countSlideNext == self.galleryInformationArray.count - 1 {
            countSlideNext = 0
        }
        else {
            countSlideNext += 1
        }
        if countSlidePrev == self.galleryInformationArray.count - 1 {
            countSlidePrev = 0
        }
        else {
            countSlidePrev += 1
        }
    }
    
    func countSliderPrev() {
        if countSlidePrev == 0 {
            countSlidePrev = self.galleryInformationArray.count - 1
        }
        else {
            countSlidePrev -= 1
        }
        if countSlideNext == 0 {
            countSlideNext = self.galleryInformationArray.count - 1
        }
        else {
            countSlideNext -= 1
        }
    }
    
    func nextPhoto() {
        self.nextPhotoImageView.frame.size.width = self.MainPhotoImageView.frame.size.width
        self.nextPhotoImageView.frame.size.height = self.MainPhotoImageView.frame.size.height
        self.nextPhotoImageView.frame.origin.x = self.MainPhotoImageView.frame.size.width
        self.nextPhotoImageView.frame.origin.y = self.MainPhotoImageView.frame.origin.y
        self.nextPhotoImageView.contentMode = .scaleAspectFill
        self.sliderBox.addSubview(nextPhotoImageView)
    }
    
    func prevPhoto() {
        self.prevPhotoImageView.frame.size.width = MainPhotoImageView.frame.size.width
        self.prevPhotoImageView.frame.size.height = MainPhotoImageView.frame.size.height
        self.prevPhotoImageView.frame.origin.x = 0 - MainPhotoImageView.frame.size.width
        self.prevPhotoImageView.frame.origin.y = MainPhotoImageView.frame.origin.y
        prevPhotoImageView.contentMode = .scaleAspectFill
        self.sliderBox.addSubview(prevPhotoImageView)
    }
    
}


