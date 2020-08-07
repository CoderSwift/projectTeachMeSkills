import Foundation


extension UIVIew: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIImagePickerControllerDelegate{
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
