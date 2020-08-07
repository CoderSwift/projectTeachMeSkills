//
//  CustomCollectionViewCell.swift
//  GallerySecurity
//
//  Created by coder on 7/13/20.
//  Copyright © 2020 cyber cradle. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewBox: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
    
    func setImage (with image: Gallery?) {
        guard let imageUrl = image?.imageUrls else {return}
        self.imageViewBox.image =  self.loadSave(fileName: imageUrl)

    }
    

}
