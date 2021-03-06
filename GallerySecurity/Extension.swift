import Foundation
import UIKit

var indexArrayGallery = Int()
var password = UserDefaults.standard.string(forKey: "Password")
var firstViewController = false

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 250 // New change object
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIImagePickerControllerDelegate{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GalleryManager.shared.getSettings().count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewBoxAspect.constant < 160 {
            self.viewBoxAspect.constant = scrollView.contentOffset.y
        }
        if scrollView.contentOffset.y < 160.5{
            self.viewBoxAspect.constant = scrollView.contentOffset.y
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthScreen = self.collectionView.frame.width
        return  CGSize(width: widthScreen/sortingDisplay , height: widthScreen/sortingDisplay )
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellCollection =  collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as?  CustomCollectionViewCell else {return UICollectionViewCell()}
        cellCollection.setImage(with: GalleryManager.shared.getSettings()[indexPath.item])
        cellCollection.imageViewBox.contentMode = UIView.ContentMode.scaleAspectFill
        cellCollection.imageViewBox.clipsToBounds = true
        return cellCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewControllerPhoto = self.storyboard?.instantiateViewController(identifier: "PhotoViewController") as! PhotoViewController
        viewControllerPhoto.modalPresentationStyle = .fullScreen
        viewControllerPhoto.indexPath = indexPath
        self.navigationController?.pushViewController(viewControllerPhoto, animated: true)
        indexArrayGallery = indexPath.row
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let imageUrlSave = saveImage(image: pickedImage) // Сохраняем data
            let settingsImage = Gallery() // ссылка на класс объектов
            settingsImage.imageUrls = imageUrlSave  //  присваеваем объекту imageUrl - data
            settingsImage.indexArray = indexPath  //  присваеваем объекту imageUrl - data
            GalleryManager.shared.setSettings(settingsImage) // Добавление в массив
            picker.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
            let settingsImageValue = GalleryInformation(indexArray: indexPath, like: false, imageUrls: imageUrlSave!, uuid: imageUrlSave!, comment: "")
            var settingsImageInformation = GalleryInformationManager.shared.getSettings()
            settingsImageInformation.append(settingsImageValue)
            GalleryInformationManager.shared.setSettings(settingsImageInformation)
            indexPath += 1
            countPhotoLoad()
        }
    }
    
}


extension UIViewController {
    func loadSave(fileName:String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
}




extension String {

func localized() -> String {
    return NSLocalizedString(self, comment: "")
}
}
