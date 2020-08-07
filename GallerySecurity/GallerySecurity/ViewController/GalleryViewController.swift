import UIKit



class GalleryViewController: UIViewController, UINavigationControllerDelegate{
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainImageGallery: UIImageView!
    @IBOutlet weak var viewBoxAspect: NSLayoutConstraint!
    @IBOutlet weak var buttonSortedThree: UIButton!
    @IBOutlet weak var buttonSortedTwo: UIButton!
    @IBOutlet weak var labelCountPhoto: UILabel!
    @IBOutlet weak var countPhoto: UILabel!
    var indexPath = 0
    var sortingDisplay:CGFloat = 2
    private var settings: Gallery?
    var buttonAddPhoto  = UIButton()
    var galleryInformation = GalleryInformationManager.shared.getSettings()
    var gallery = GalleryManager.shared.getSettings()
    let imagePicker = UIImagePickerController()
    var withTimeInterval = 0.3
    var buttonAddPhotoConstantWidthHeight = 60
    var buttonAddPhotoConstantLeftRight = 20
    var buttonAddPhotoSize = 60
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupMainImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        imagePicker.delegate = self
        createCustomCollectionViewCell()
        createButtonAddPhoto()
        collectionView.reloadData()
        countPhotoLoad()
    }
    
    @IBAction func buttonSortedTwoInside(_ sender: UIButton) {
        UIView.animate(withDuration: withTimeInterval, animations: {
            sender.alpha = 1
            self.buttonSortedThree.alpha = 0.4
        })
        sortingDisplay = 2
        self.collectionView.reloadData()
        
    }
    @IBAction func buttonSortedThreeInside(_ sender: UIButton) {
        UIView.animate(withDuration: withTimeInterval, animations: {
            sender.alpha = 1
            self.buttonSortedTwo.alpha = 0.4
        })
        sortingDisplay = 3
        self.collectionView.reloadData()
    }
    @objc func buttonAddPhotoDown() {
        buttonAddPhoto.backgroundColor = UIColor(hex: "#229D71ff")
    }
    
    @objc func buttonAddPhotoTouchUpInside() {
        createAlertAddPhoto()
        buttonAddPhoto.backgroundColor = UIColor(hex: "#312E3Fff")
    }
    
    
    
    func setupMainImage() {
        if gallery.count == 0 {
            self.mainImageGallery.image = UIImage(named: "image")
        } else{
            guard let imageUrl = gallery.randomElement()?.imageUrls else {return}
            guard let image = loadSave(fileName:imageUrl) else {return}
            self.mainImageGallery.image = image
        }
    }
    
    func countPhotoLoad() {
        var gallery = GalleryManager.shared.getSettings()
        self.countPhoto.text = "\(gallery.count)  " + "Photo".localized()
    }
    
    func createCustomCollectionViewCell() {
        let nibCollectionViewCell = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        self.collectionView.register(nibCollectionViewCell, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
   
    
    func createButtonAddPhoto() {
        buttonAddPhoto  = UIButton()
        buttonAddPhoto.frame = CGRect(x: 0, y: 0, width: buttonAddPhotoSize, height: buttonAddPhotoSize)
        buttonAddPhoto.backgroundColor = UIColor(hex: "#312E3Fff")
        buttonAddPhoto.layer.cornerRadius = buttonAddPhoto.frame.size.width/2
        buttonAddPhoto.layer.shadowOffset = CGSize(width: 0, height: 4)
        buttonAddPhoto.layer.shadowColor = UIColor(white: 0x000000, alpha: 0.25).cgColor
        buttonAddPhoto.layer.shadowOpacity = 1
        buttonAddPhoto.layer.shadowRadius = 4
        buttonAddPhoto.layer.masksToBounds = false
        buttonAddPhoto.setImage(UIImage(named: "plus"), for: .normal)
        buttonAddPhoto.setImage(UIImage(named: "plus"), for: .highlighted)
        buttonAddPhoto.addTarget(self, action: #selector(buttonAddPhotoDown), for: .touchDown)
        buttonAddPhoto.addTarget(self, action: #selector(buttonAddPhotoTouchUpInside), for: .touchUpInside)
        self.view.addSubview(buttonAddPhoto)
        buttonAddPhoto.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAddPhoto.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -CGFloat(buttonAddPhotoConstantLeftRight)),
            buttonAddPhoto.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -CGFloat(buttonAddPhotoConstantLeftRight)),
            buttonAddPhoto.widthAnchor.constraint(equalToConstant: CGFloat(buttonAddPhotoConstantWidthHeight)),
            buttonAddPhoto.heightAnchor.constraint(equalToConstant: CGFloat(buttonAddPhotoConstantWidthHeight))
        ])
    }
    
    func createAlertAddPhoto() {
        let alertPhoto = UIAlertController(title: nil, message: "Choose how to add photos".localized(), preferredStyle: .actionSheet)
        let photoAddGallery = UIAlertAction(title: "Photo library".localized(), style: .default) { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoAddCamera = UIAlertAction(title: "Camera".localized(), style: .default) { (alert: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (alert: UIAlertAction!) in
        }
        alertPhoto.addAction(photoAddCamera)
        alertPhoto.addAction(photoAddGallery)
        alertPhoto.addAction(cancelAction)
        self.present(alertPhoto, animated: true, completion: nil)
    }
    
}

